class CreateEvaluationScoreCards < ActiveRecord::Migration
  def change
    create_table :evaluation_score_cards do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :evaluation, index: true
      t.references :user, index: true
      t.references :committee, index: true
      t.string :role
      t.integer :task_score
      t.integer :ability_score

      t.userstamps
      t.timestamps
    end
  end
end
