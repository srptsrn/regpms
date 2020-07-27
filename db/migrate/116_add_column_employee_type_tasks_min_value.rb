class AddColumnEmployeeTypeTasksMinValue < ActiveRecord::Migration
  def change
    add_column :employee_type_tasks, :min_value, :integer
  end
end
