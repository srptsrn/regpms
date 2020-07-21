class CreateEmployeeTypeUsers < ActiveRecord::Migration
  def change
    create_table :employee_type_users do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :employee_type, index: true
      t.references :user, index: true
      t.references :evaluation, index: true

      t.userstamps
      t.timestamps
    end
    
    add_reference :employee_type_task_groups, :employee_type_user, index: true

  end
end
