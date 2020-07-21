class CreateUserAccessLogs < ActiveRecord::Migration
  def change
    create_table :user_access_logs do |t|
      t.references :user, index: true
      t.string :username, index: true
      t.string :ip, index: true
      t.string :controller_name, index: true
      t.string :action_name, index: true
      t.text :params
      t.integer :params_id
      t.datetime :log_time

      t.userstamps
      t.timestamps
    end
  end
end
