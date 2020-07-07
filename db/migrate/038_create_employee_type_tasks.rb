class CreateEmployeeTypeTasks < ActiveRecord::Migration
  def change
    create_table :employee_type_tasks do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.integer :sorting
      t.references :employee_type_task_group, index: true
      t.references :task, index: true
      t.float :weight

      t.userstamps
      t.timestamps
    end
  end
end
