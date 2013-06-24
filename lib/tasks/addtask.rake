task :addtask => :environment do
  puts "Running addtask..."
  params = ENV['params']
  puts "params: #{params}"

  batch_size = 100
  for i in 1..10 do
    t = AnalysisTask.new(project_name: "acibmoss",
                         description: "blast runs",
                         script_params:
        "{'START_INDEX': '#{(i-1)*batch_size}', 'BATCH_SIZE': '#{batch_size}', 'QUERY_FILE': 'M2_L008_good_1.fastq.gz'",
                         status: "waiting",
                         script_template: "blastnt_template.sh"
    )
    t.save
  end

  puts "server list:\n---------------"
  servers = Server.all()
  for s in servers do
    puts "#{s.ip} -> #{s.status}"
  end
end

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
  `ssh #{server.adminuser}@#{server.ip} 'cd #{server.rootdir}; mkdir -p runs/#{analysistask.id}/script; mkdir -p runs/#{analysistask.id}/log; mkdir -p runs/#{analysistask.id}/result'`

  scripts = ["eval_str.sh", "workflow_utils.sh", "timediff.py", "notify_by_mail.py", "fasta_split.py", "fastq2fasta.py"]
  for s in scripts
    cmd ="scp script/common/#{s} #{server.adminuser}@#{server.ip}:#{server.rootdir}/runs/#{analysistask.id}/script"
    puts "\tcopying: #{cmd}"
    `#{cmd}`
  end

  script_instance_fname = analysistask.script_template.sub("_template", "_inst_#{analysistask.id}")
  params = get_params( analysistask.script_params )
  params["RUN_ID"] = analysistask.id.to_s
  params["ROOT_DIR"] = server.rootdir
  subs_template("script/#{analysistask.script_template}", params, "tmp/#{script_instance_fname}")
  cmd ="scp tmp/#{script_instance_fname} #{server.adminuser}@#{server.ip}:#{server.rootdir}/runs/#{analysistask.id}/script"
  puts "\tcopying: #{cmd}"
  `#{cmd}`
  cmd = "ssh #{server.adminuser}@#{server.ip} 'RUN_DIR=#{server.rootdir}/runs/#{analysistask.id}; SCRIPT_DIR=$RUN_DIR/script; cd $RUN_DIR; chmod +x $SCRIPT_DIR/#{script_instance_fname}; nohup $SCRIPT_DIR/#{script_instance_fname} >> log/nohup.log  2>> log/nohup.log &'"
  puts "\texecuting: #{cmd}"
  `#{cmd}`
end

task :checkqueue => :environment do
  puts "Running checkqueue..."
  t = AnalysisTask.where("status == 'waiting'").order(:created_at).first
  if not t.nil?
    s = Server.find_by_status("idle")
    if not s.nil?
      s.status = "running"
      t.status = "inprogress"

      # TODO deploy script to server
      puts "deploying task #{t.id} to #{s.ip}"
      puts "executing: #{t.script_template}"
      puts "\tparams: #{t.script_params}"
      deploy(t, s)

      t.server_id = s.id
      s.save
      t.save
    else
      puts "No free servers"
    end
  else
    puts "No idle tasks"
  end

end

task :reset => :environment do
  t = AnalysisTask.find_by_id(8)
  t.status = "waiting"
  s = Server.find_by_ip("192.168.2.211")
  s.status = "idle"
  t.save
  s.save
end