class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :message, index: true
      t.references :user, index: true
      t.text :topic
      t.text :body
      t.string :workflow_state
      t.references :workflow_state_updater, index: true

      t.userstamps
      t.timestamps
    end
    
    create_table :message_receivers do |t|
      t.references :message, index: true
      t.references :user, index: true
      t.string :receiver_type
      t.string :workflow_state
      t.references :workflow_state_updater, index: true

      t.userstamps
      t.timestamps
    end
  end
end
