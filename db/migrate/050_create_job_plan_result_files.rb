class CreateJobPlanResultFiles < ActiveRecord::Migration
  def change
    create_table :job_plan_result_files do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :job_plan_result, index: true
      t.attachment :file
      t.text :description

      t.userstamps
      t.timestamps
    end
  end
end
