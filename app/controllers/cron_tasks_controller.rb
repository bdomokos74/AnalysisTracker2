require 'json'

class CronTasksController < ApplicationController

  def subs_template(template_fname, params, output_fname)
    puts "reading #{template_fname}"
    f = File.open(template_fname, "r")
    template = f.read
    f.close

    for k in params.keys
      puts "\t#{k}"
      template = template.gsub("@#{k}@", params[k])
    end

    outf = File.open(output_fname, "w")
    outf.write(template)
    outf.close
  end

  def get_params(j)
    params = JSON.parse(j)
    return params
  end

  def deploy(analysistask, server)
    cmd="script/common/ssh_wrapper.sh #{server.adminuser}@#{server.ip} 'cd #{server.rootdir}; mkdir -p runs/#{analysistask.id}/script; mkdir -p runs/#{analysistask.id}/log; mkdir -p runs/#{analysistask.id}/result'"
    puts cmd
    system("whoami")
    result=`#{cmd}`
    if result.to_i != 0
      return(false)
    end

    scripts = ["eval_str.sh", "workflow_utils.sh", "timediff.py", "notify_by_mail.py", "fasta_split.py", "fastq2fasta.py", "bookkeeping.py", "lcs_proc.py"]
    for s in scripts
      cmd ="scp script/common/#{s} #{server.adminuser}@#{server.ip}:#{server.rootdir}/runs/#{analysistask.id}/script"
      puts "\tcopying: #{cmd}"
      `#{cmd}`
    end

    script_instance_fname = analysistask.script_template.sub("_template", "_inst_#{analysistask.id}")
    params = self.get_params( analysistask.script_params )
    params["RUN_ID"] = analysistask.id.to_s
    params["ROOT_DIR"] = server.rootdir
    if ENV["RAILS_ENV"] == "production"
      params["SERVER_URL"] = "http://192.168.2.210:3200"
    else
      params["SERVER_URL"] = "http://192.168.2.210:3000"
    end

    self.subs_template("script/#{analysistask.script_template}", params, "tmp/#{script_instance_fname}")
    cmd ="scp tmp/#{script_instance_fname} #{server.adminuser}@#{server.ip}:#{server.rootdir}/runs/#{analysistask.id}/script"
    puts "\tcopying: #{cmd}"
    `#{cmd}`
    cmd = "ssh #{server.adminuser}@#{server.ip} 'RUN_DIR=#{server.rootdir}/runs/#{analysistask.id}; SCRIPT_DIR=$RUN_DIR/script; cd $RUN_DIR; chmod +x $SCRIPT_DIR/#{script_instance_fname}; nohup $SCRIPT_DIR/#{script_instance_fname} >> log/nohup.log  2>> log/nohup.log &'"
    puts "\texecuting: #{cmd}"
    `#{cmd}`
    return(true)
  end

  def check_queue
    if params[:cmd] != "checkqueue"
      respond_to do |format|
        format.json { render :json => -1 }
      end
      return
    end

    puts "Checking notifications... #{}"
    # process notifications
    results = AnalysisResult.all
    for r in results
      t = AnalysisTask.find(r.task_id)
      if r.status != "0"
        t.status = "failed"
        puts "fail #{t.id}"
      else
        t.status = "success"
        puts "success #{t.id}"
      end
      t.duration = r.duration
      s = Server.find(t.server_id)
      s.status = "idle"
      s.save
      t.save
      r.destroy
    end

    waiting_tasks = AnalysisTask.where("status = 'waiting'").order(:created_at).all
    for t in waiting_tasks
      s = Server.find_by_status("idle")
      if not s.nil?
        s.status = "running"
        t.status = "inprogress"

        # TODO deploy script to server
        puts "deploying #{t.id} to #{s.ip}"
        #puts "executing: #{t.script_template}"
        #puts "\tparams: #{t.script_params}"
        succ = self.deploy(t, s)
        if not succ
          puts "Failed to deploy, rolling back..."
        else
          t.server_id = s.id
          s.save
          t.save
          #puts "Deployed..."
        end
      else
        puts "No more free servers"
        break
      end
    end

    respond_to do |format|
      format.json { render :json => 0 }
    end

  end

end
