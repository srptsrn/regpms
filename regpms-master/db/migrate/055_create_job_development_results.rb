class CreateJobDevelopmentResults < ActiveRecord::Migration
  def change
    create_table :job_development_results do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :user, index: true
      t.references :evaluation, index: true
      t.references :job_development, index: true
      t.references :job_result_template, index: true
      t.text :name
      t.integer :duration
      t.float :expect_qty
      t.float :qty
      t.string :unit
      t.text :description
      t.references :approver, index: true

      t.userstamps
      t.timestamps
    end
  end
end
