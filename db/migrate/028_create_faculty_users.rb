class CreateFacultyUsers < ActiveRecord::Migration
  def change
    create_table :faculty_users do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :faculty, index: true
      t.references :user, index: true

      t.userstamps
      t.timestamps
    end
  end
end
