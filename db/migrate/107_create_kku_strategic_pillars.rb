class CreateKkuStrategicPillars < ActiveRecord::Migration
  def change
    create_table :kku_strategic_pillars do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.integer :no
      t.string :name

      t.userstamps
      t.timestamps
    end
    add_reference :projects, :kku_strategic_pillar, index: true
  end
end
