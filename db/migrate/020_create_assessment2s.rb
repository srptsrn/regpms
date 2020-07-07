class CreateAssessment2s < ActiveRecord::Migration
  def change
    create_table :assessment2s do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :user, index: true
      t.references :evaluation, index: true
      t.references :committee, index: true
      t.string :role
      t.integer :score111
      t.integer :score112
      t.integer :score113
      t.integer :score114
      t.integer :score121
      t.integer :score122
      t.integer :score123
      t.integer :score124
      t.integer :score211
      t.integer :score212
      t.integer :score213
      t.integer :score214
      t.integer :score215
      t.integer :score221
      t.integer :score222
      t.integer :score223
      t.integer :score224
      t.text :comment1
      t.text :comment2

      t.userstamps
      t.timestamps
    end
  end
end
