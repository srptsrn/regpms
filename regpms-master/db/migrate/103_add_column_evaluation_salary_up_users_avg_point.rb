class AddColumnEvaluationSalaryUpUsersAvgPoint < ActiveRecord::Migration
  def change
    
    add_column :evaluation_salary_up_users, :avg_point, :float
        
  end
end
