class CreateAnalysisTasks < ActiveRecord::Migration
  def change
    create_table :analysis_tasks do |t|
      t.integer :server_id
      t.integer :run_id
      t.string :project_name
      t.string :description
      t.string :script_template
      t.string :script_params
      t.integer :duration
      t.string :status

      t.timestamps
    end
  end
end
