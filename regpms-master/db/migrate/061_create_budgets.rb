class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :project, index: true
      t.integer :sorting
      t.references :budget_type, index: true
      t.text :description
      t.float :amount

      t.userstamps
      t.timestamps
    end
  end
end
