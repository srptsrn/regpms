class CreatePositionCapacityGroups < ActiveRecord::Migration
  def change
    create_table :position_capacity_groups do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.integer :sorting
      t.references :position, index: true
      t.string :name

      t.userstamps
      t.timestamps
    end
  end
end
