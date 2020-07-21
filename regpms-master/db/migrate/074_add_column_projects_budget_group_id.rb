class AddColumnProjectsBudgetGroupId < ActiveRecord::Migration
  def change
    add_reference :projects, :budget_group, index: true
  end
end
