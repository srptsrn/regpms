class CreateMeasures < ActiveRecord::Migration
  def change
    create_table :measures do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :tactic, index: true
      t.integer :no
      t.string :name

      t.userstamps
      t.timestamps
    end
    add_reference :projects, :measure, index: true
  end
end
