class CreatePositionTypes < ActiveRecord::Migration
  def change
    create_table :position_types do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.string :name
      t.integer :sorting

      t.userstamps
      t.timestamps
    end
  end
end
