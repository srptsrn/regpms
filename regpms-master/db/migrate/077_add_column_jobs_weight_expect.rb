class AddColumnJobsWeightExpect < ActiveRecord::Migration
  def change
    
    add_column :job_plans, :weight, :float
    add_column :job_plans, :expect, :integer
    
    add_column :job_routines, :weight, :float
    add_column :job_routines, :expect, :integer
    
    add_column :job_vices, :weight, :float
    add_column :job_vices, :expect, :integer
    
    add_column :job_developments, :weight, :float
    add_column :job_developments, :expect, :integer
    
  end
end
