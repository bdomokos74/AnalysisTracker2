
task :addtask => :environment do
  puts "Running addtask2..."
  params = ENV['params']
  puts "params: #{params}"

  batch_size = 2000000
  for i in 1..50 do
    startindex = (i-1)*batch_size
    len = batch_size
    readnum = 54658254
    if startindex > readnum
      break
    end
    if startindex+len > readnum
      len = readnum-startindex
    end
    t = AnalysisTask.new(project_name: "acibmoss",
                         description: "blast runs",
                         script_params:
        "{\"START_INDEX\": \"#{startindex}\", \"BATCH_SIZE\": \"#{len}\", \"QUERY_FILE\": \"M2norm_L008_R2_prinseq_good.fastq.gz\"}",
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

task :neisseria_addtask => :environment do
  puts "Running addtask2..."
  params = ENV['params']
  puts "params: #{params}"

  batch_size = 20
  contignum = 2002-426
  for i in 1..100 do
    startindex = (i-1)*batch_size
    len = batch_size
    if startindex > contignum
      break
    end
    if startindex+len > contignum
      len = contignum-startindex
    end
    t = AnalysisTask.new(project_name: "neisseria",
                         description: "longest common substring",
                         script_params: "{\"FILE_A\": \"neisseria/Neisseria_FA1090.fa\", \"FILE_B\": \"neisseria/Chlamydia_DUW-3CX.fa\",
                                        \"SKIP_FILE\": \"neisseria/contigs_done.txt\", \"START_INDEX\": \"#{startindex}\", \"BATCH_SIZE\": \"#{len}\"}",
                         status: "waiting",
                         script_template: "primer_lcs_template.sh"
    )
    t.save
  end

  puts "server list:\n---------------"
  servers = Server.all()
  for s in servers do
    puts "#{s.ip} -> #{s.status}"
  end
end

task :retry => :environment do
  failed_tasks = AnalysisTask.where("status = 'failed'").order(:created_at).all
  for t in failed_tasks
    s = Server.find(t.server_id)
    puts "executing at #{s.ip}: cd #{s.rootdir}/runs/; rm -rf #{t.id}"
    #!!t.id.match(/^[0-9]+$/)
    if not t.id.nil?
      cmd = "ssh #{s.adminuser}@#{s.ip} 'cd #{s.rootdir}/runs/; rm -rf #{t.id}'"
      `#{cmd}`
    else
      puts "wrong format!! #{t.id}"
    end
    t.status = "waiting"
    t.server_id = nil
    t.duration = nil
    t.save
  end
end

task :reset => :environment do
  a = AnalysisTask.all
  for t in a
    t.status = "waiting"
    t.server_id = nil
    t.save
  end

  a = Server.all
  for s in a
    s.status = "idle"
    s.save
  end
end

task :initservers => :environment do
  ips = ["192.168.2.210", "192.168.2.211", "192.168.2.212"]
  for i in ips
    s = Server.new
    s.ip = i
    s.status = "idle"
    s.adminuser = "bdomokos"
    s.rootdir = "/data/projects/remote_runs"
    s.save
  end
end
