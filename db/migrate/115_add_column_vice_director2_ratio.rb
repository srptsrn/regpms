class AddColumnViceDirector2Ratio < ActiveRecord::Migration
  def change
    add_column :evaluation_employee_types, :vice_director2_ratio, :float
    add_column :evaluation_employee_types, :vice_director3_ratio, :float
    add_column :evaluation_employee_types, :secretary_ratio, :float
    add_reference :sections, :vice_director2, index: true
    add_reference :sections, :vice_director3, index: true
  end
end
