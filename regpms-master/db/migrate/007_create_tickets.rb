class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :no
      t.string :name
      t.text :description
      t.string :priority
      t.string :workflow_state
      t.references :workflow_state_updater, index: true

      t.userstamps
      t.timestamps
    end
    create_table :ticket_attachments do |t|
      t.references :ticket, index: true
      t.attachment :file

      t.userstamps
      t.timestamps
    end
    create_table :ticket_comments do |t|
      t.references :ticket, index: true
      t.text :description
      t.string :workflow_state
      t.references :workflow_state_updater, index: true

      t.userstamps
      t.timestamps
    end
    create_table :ticket_comment_attachments do |t|
      t.references :ticket_comment, index: true
      t.attachment :file

      t.userstamps
      t.timestamps
    end
    create_table :tickets_users do |t|
      t.references :ticket, index: true
      t.references :user, index: true
    end
  end
end
