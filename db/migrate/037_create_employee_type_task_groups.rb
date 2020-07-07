class CreateEmployeeTypeTaskGroups < ActiveRecord::Migration
  def change
    create_table :employee_type_task_groups do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.integer :sorting
      t.references :employee_type, index: true
      t.string :name

      t.userstamps
      t.timestamps
    end
  end
end
