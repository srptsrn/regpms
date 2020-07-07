class CreateBudgetTypes < ActiveRecord::Migration
  def change
    create_table :budget_types do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.string :name

      t.userstamps
      t.timestamps
    end
  end
end
