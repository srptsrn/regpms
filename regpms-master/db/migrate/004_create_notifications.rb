class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true
      t.text :description
      t.string :priority
      t.string :resource_class
      t.references :resource, index: true
      t.text :url
      t.string :workflow_state
      t.references :workflow_state_updater, index: true

      t.userstamps
      t.timestamps
    end
  end
end
