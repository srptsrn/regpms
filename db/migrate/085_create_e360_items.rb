class CreateE360Items < ActiveRecord::Migration
  def change
    create_table :e360_items do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :evaluation, index: true
      t.integer :sorting
      t.text :name

      t.userstamps
      t.timestamps
    end
  end
end
