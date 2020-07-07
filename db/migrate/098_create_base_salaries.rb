class CreateBaseSalaries < ActiveRecord::Migration
  def change
    create_table :base_salaries do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :evaluation, index: true
      t.references :position_level, index: true
      t.float :min_low
      t.float :max_low
      t.float :base_low
      t.float :min_high
      t.float :max_high
      t.float :base_high
      t.text :remark

      t.userstamps
      t.timestamps
    end
  end
end
