class CreateEvaluationUserFinals < ActiveRecord::Migration
  def change
    create_table :evaluation_user_finals do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :evaluation, index: true
      t.references :director, index: true
      t.references :user, index: true
      t.datetime :director_at
      t.datetime :user_at
      t.float :final_task_score
      t.float :final_ability_score
      t.float :leader_task_score
      t.float :leader_ability_score
      t.float :staff_task_score
      t.float :staff_ability_score

      t.userstamps
      t.timestamps
    end
    
    add_column :evaluations, :director_confirm_start_date, :date
    add_column :evaluations, :director_confirm_end_date, :date
    
  end
end
