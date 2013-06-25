class CreateAnalysisResults < ActiveRecord::Migration
  def change
    create_table :analysis_results do |t|
      t.integer :task_id
      t.string :status
      t.integer :duration

      t.timestamps
    end
  end
end
