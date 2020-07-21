class CreateEvaluationPrinciples < ActiveRecord::Migration
  def change
    create_table :evaluation_principles do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :evaluation, index: true
      t.references :task, index: true
      t.text :principle1
      t.text :principle2
      t.text :principle3
      t.text :principle4
      t.text :principle5

      t.userstamps
      t.timestamps
    end
  end
end
