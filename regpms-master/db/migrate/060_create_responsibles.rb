class CreateResponsibles < ActiveRecord::Migration
  def change
    create_table :responsibles do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :project, index: true
      t.integer :sorting
      t.references :user, index: true
      t.string :prefix
      t.string :firstname
      t.string :lastname
      t.string :position

      t.userstamps
      t.timestamps
    end
  end
end
