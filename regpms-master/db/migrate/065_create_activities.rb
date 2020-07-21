class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :project, index: true
      t.integer :sorting
      t.text :name
      t.date :from_date
      t.date :to_date
      t.text :location
      t.integer :number_of_participant
      t.text :description

      t.userstamps
      t.timestamps
    end
  end
end
