class AddColumnBudgetGroupsShortName < ActiveRecord::Migration
  def change
    
    add_column :budget_groups, :short_name, :string
        
  end
end
