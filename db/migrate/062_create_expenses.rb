class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :project, index: true
      t.integer :sorting
      t.references :budget_type, index: true
      t.date :date
      t.text :description
      t.float :amount
      t.string :by

      t.userstamps
      t.timestamps
    end
  end
end
