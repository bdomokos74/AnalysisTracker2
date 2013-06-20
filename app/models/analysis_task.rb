class AnalysisTask < ActiveRecord::Base
  attr_accessible :description, :duration, :project_name, :run_id, :script_params, :script_template, :server_id, :status
end
