class AddColumnEvaluationSalaryUpUsersExtra < ActiveRecord::Migration
  def change
    
    add_column :evaluation_salary_up_users, :extra_money, :float
    add_column :evaluation_salary_up_users, :remark, :text
        
  end
end
