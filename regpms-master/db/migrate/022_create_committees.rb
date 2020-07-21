class CreateCommittees < ActiveRecord::Migration
  def change
    create_table :committees do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :evaluation, index: true
      t.references :user, index: true

      t.userstamps
      t.timestamps
    end
  end
end
