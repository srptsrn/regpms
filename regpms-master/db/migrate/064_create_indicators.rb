class CreateIndicators < ActiveRecord::Migration
  def change
    create_table :indicators do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :project, index: true
      t.integer :sorting
      t.text :description
      t.float :target
      t.float :result1
      t.float :result2
      t.float :result3

      t.userstamps
      t.timestamps
    end
  end
end
