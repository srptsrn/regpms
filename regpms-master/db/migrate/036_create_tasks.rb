class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.integer :sorting
      t.string :name
      t.attachment :file

      t.userstamps
      t.timestamps
    end
  end
end
