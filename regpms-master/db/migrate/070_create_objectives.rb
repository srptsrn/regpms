class CreateObjectives < ActiveRecord::Migration
  def change
    create_table :objectives do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :project, index: true
      t.integer :sorting
      t.text :description

      t.userstamps
      t.timestamps
    end
  end
end
