class CreateEvaluationSalaryUpUsers < ActiveRecord::Migration
  def change
    create_table :evaluation_salary_up_users do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :evaluation, index: true
      t.references :evaluation_salary_up, index: true
      t.references :user, index: true
      t.references :position_level, index: true
      t.float :salary
      t.float :base_salary
      t.float :base_salary_min
      t.float :base_salary_max
      t.boolean :is_eligible
      t.boolean :is_work_hour_passed
      t.integer :lost_count
      t.integer :late_count
      t.float :leave_count
      t.float :point
      t.float :percent_of_min_up
      t.float :salary_min_up
      t.float :percent_of_up
      t.float :salary_up

      t.userstamps
      t.timestamps
    end
  end
end
