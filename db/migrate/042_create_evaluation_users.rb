class CreateEvaluationUsers < ActiveRecord::Migration
  def change
    create_table :evaluation_users do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :user, index: true
      t.references :evaluation, index: true
      t.references :committee, index: true
      t.string :role
      t.text :comment1
      t.text :comment2
      t.float :position_capacity_total
      t.float :employee_type_task_total

      t.userstamps
      t.timestamps
    end
  end
end
