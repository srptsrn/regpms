class AddColumnUsersIsExceptEvaluation < ActiveRecord::Migration
  def change
    
    add_column :users, :is_except_evaluation, :boolean
        
  end
end
