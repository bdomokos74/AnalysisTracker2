namespace :collect do
  task :collect_results => :environment do
    puts "Running collect_results..."
    # also add /data/projects/remote_runs/data/neisseria/nei_ch_filt.json
    results = AnalysisTask.find_all_by_project_name_and_status("neisseria", "success")
    for r in results do
      s = Server.find(r.server_id)
      cmd="scp #{s.adminuser}@#{s.ip}:#{s.rootdir}/runs/#{r.id}/result/matches*.json /data/projects/current/sex_primers/results_collected"
      result = `#{cmd}`
      code = $?
      puts "task id: #{r.id}, cmd: [#{cmd}], result: #{code.to_i}"

    end
  end
end


