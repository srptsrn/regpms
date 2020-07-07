class CreateBudgetGroups < ActiveRecord::Migration
  def change
    create_table :budget_groups do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.string :name

      t.userstamps
      t.timestamps
    end
    
    add_reference :expenses, :budget_group, index: true
  end
end
