class AddColumnJobAllSelfPoint < ActiveRecord::Migration
  def change
    
    add_column :job_routines, :self_point, :integer
    add_column :job_plans, :self_point, :integer
    add_column :job_vices, :self_point, :integer
    add_column :job_developments, :self_point, :integer
    
  end
end
