class CreateEmployeeTypeTaskUsers < ActiveRecord::Migration
  def change
    create_table :employee_type_task_users do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :employee_type_task, index: true
      t.references :user, index: true
      t.references :evaluation, index: true
      t.references :committee, index: true
      t.string :role
      t.float :weight
      t.integer :score
      t.float :score_real

      t.userstamps
      t.timestamps
    end
  end
end
