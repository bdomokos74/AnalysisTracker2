task :addtask => :environment do
  puts "Running addtask..."
  params = ENV['params']
  puts "params: #{params}"

  batch_size = 1000000
  for i in 1..10 do
    t = AnalysisTask.new(project_name: "acibmoss",
                         description: "blast runs",
                         script_params:
        "{'START_INDEX': '#{(i-1)*batch_size}', 'BATCH_SIZE': '#{batch_size}', 'QUERY_FILE': 'M2_L008_good_1.fastq'",
                         status: "waiting",
                         script_template: "blastn_template.sh"
    )
    t.save
  end

  puts "server list:\n---------------"
  servers = Server.all()
  for s in servers do
    puts "#{s.ip} -> #{s.status}"
  end
end

def deploy(analysistask, server)
  puts "deploying task #{analysistask.id} to #{server.ip}"
  `ssh #{server.adminuser}@#{server.ip} 'cd #{server.rootdir}; mkdir -p runs/${analysistask.id}/script; mkdir runs/${analysistask.id}/log; mkdir runs/${analysistask.id}/result'`

  ### CONTINUE HERE!!!!
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
puts t.script_params
end

