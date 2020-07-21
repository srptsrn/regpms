class CreatePolicies < ActiveRecord::Migration
  def change
    create_table :policies do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :policy, index: true
      t.string :code
      t.text :name

      t.userstamps
      t.timestamps
    end
  end
end
