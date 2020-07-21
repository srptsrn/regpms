class CreateProblemSuggesstions < ActiveRecord::Migration
  def change
    create_table :problem_suggesstions do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :project, index: true
      t.integer :sorting
      t.text :description

      t.userstamps
      t.timestamps
    end
  end
end
