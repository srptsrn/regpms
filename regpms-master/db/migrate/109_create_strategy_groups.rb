class CreateStrategyGroups < ActiveRecord::Migration
  def change
    create_table :strategy_groups do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.integer :no
      t.string :name

      t.userstamps
      t.timestamps
    end
    add_reference :strategies, :strategy_group, index: true
    add_reference :projects, :strategy_group, index: true
  end
end
