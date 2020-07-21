class AddColumnEmployeeTypeTasksCriteria < ActiveRecord::Migration
  def change
    
    add_column :employee_type_tasks, :criteria1, :text
    add_column :employee_type_tasks, :criteria2, :text
    add_column :employee_type_tasks, :criteria3, :text
    add_column :employee_type_tasks, :criteria4, :text
    add_column :employee_type_tasks, :criteria5, :text
    
  end
end
