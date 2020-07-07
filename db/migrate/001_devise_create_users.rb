class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table :workflow_state_logs do |t|
      t.string :resource_class
      t.integer :resource_id
      t.string :state_from
      t.string :state_to
      t.string :event
      t.text :serialized_object
      t.text :description

      t.userstamps
      t.timestamps
    end
    
    create_table :user_groups do |t|
      t.string :name

      ## RoleModel
      t.integer  :roles_mask

      t.userstamps
      t.timestamps
    end
    
    create_table(:users) do |t|
      
      t.string :username,           null: false, default: ""
      
      t.string   :pid
      t.string   :prefix
      t.string   :firstname
      t.string   :lastname
      t.references :position
      t.references :employee_type
      
      t.attachment :avatar
      
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      ## RoleModel
      t.integer  :roles_mask

      # workflow_state
      t.string :workflow_state
      t.references :workflow_state_updater

      t.string :locale
      t.string :timezone
      t.string :theme
      
      # user_group
      t.references :user_group

      t.userstamps
      t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
  end

  def migrate(direction)
    super # Let Rails do its thing as usual...

    if direction == :up # ...but then do something extra if we're going 'up.'
      u = User.create(
        username: "batt", 
        password: "1q2w3e4r", 
        password_confirmation: "1q2w3e4r", 
        email: "phongphat.kangkong@gmail.com", 
        workflow_state: "enabled", 
        pid: "3309901618152", 
        prefix: "Mr.", 
        firstname: "Phongphat", 
        lastname: "Kangkong"
      )
      
      u.confirmation_token = nil
      u.confirmed_at = Time.current
      u.roles = [:ibattz]
      u.save
    end
  end
end
