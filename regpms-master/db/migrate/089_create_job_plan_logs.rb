class CreateJobPlanLogs < ActiveRecord::Migration
  def change
    create_table :job_plan_logs do |t|
      t.references :job_plan, index: true
      t.text :name
      t.integer :expect
      t.float :weight

      t.userstamps
      t.timestamps
    end
  end
end
