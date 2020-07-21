class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.string :name
      t.references :leader, index: true

      t.userstamps
      t.timestamps
    end
  end
end
