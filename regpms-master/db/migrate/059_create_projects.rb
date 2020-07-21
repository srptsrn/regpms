class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :project, index: true
      t.string :code
      t.text :name
      t.references :policy, index: true
      t.text :rationale
      t.text :objective
      t.date :from_date
      t.date :to_date
      t.float :budget_amount

      t.userstamps
      t.timestamps
    end
  end
end
