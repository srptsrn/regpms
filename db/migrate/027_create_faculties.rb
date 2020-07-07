class CreateFaculties < ActiveRecord::Migration
  def change
    create_table :faculties do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.string :name
      t.references :dean, index: true
      t.references :leader, index: true

      t.userstamps
      t.timestamps
    end
  end
end
