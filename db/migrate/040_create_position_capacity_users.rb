class CreatePositionCapacityUsers < ActiveRecord::Migration
  def change
    create_table :position_capacity_users do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :position_capacity, index: true
      t.references :user, index: true
      t.references :evaluation, index: true
      t.references :committee, index: true
      t.string :role, index: true
      t.float :expect
      t.float :weight
      t.integer :score
      t.float :score_real_expect
      t.float :score_real_100
      t.float :score_weight
      t.float :score_real

      t.userstamps
      t.timestamps
    end
  end
end
