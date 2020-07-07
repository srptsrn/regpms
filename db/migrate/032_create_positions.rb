class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.string :name
      t.references :position_type, index: true

      t.userstamps
      t.timestamps
    end
  end
end
