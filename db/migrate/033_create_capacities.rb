class CreateCapacities < ActiveRecord::Migration
  def change
    create_table :capacities do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.string :name
      t.attachment :file

      t.userstamps
      t.timestamps
    end
  end
end
