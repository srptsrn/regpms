class CreateActivityFiles < ActiveRecord::Migration
  def change
    create_table :activity_files do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :activity, index: true
      t.attachment :file

      t.userstamps
      t.timestamps
    end
  end
end
