class CreatePositionCapacities < ActiveRecord::Migration
  def change
    create_table :position_capacities do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.integer :sorting
      t.references :position_capacity_group, index: true
      t.references :capacity, index: true
      t.float :weight
      t.float :expect

      t.userstamps
      t.timestamps
    end
  end
end
