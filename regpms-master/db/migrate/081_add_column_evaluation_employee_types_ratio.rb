class AddColumnEvaluationEmployeeTypesRatio < ActiveRecord::Migration
  def change
    
    add_column :evaluation_employee_types, :director_ratio, :float
    add_column :evaluation_employee_types, :vice_director_ratio, :float
    add_column :evaluation_employee_types, :vice_director2_ratio, :float
    add_column :evaluation_employee_types, :vice_director3_ratio, :float
    add_column :evaluation_employee_types, :section_leader_ratio, :float
    add_column :evaluation_employee_types, :section_vice_leader_ratio, :float
    
  end
end
