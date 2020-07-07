class CreateE360Users < ActiveRecord::Migration
  def change
    create_table :e360_users do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :evaluation, index: true
      t.references :user, index: true
      t.references :committee, index: true
      t.string :role

      t.userstamps
      t.timestamps
    end
  end
end
