class CreateEvaluationSalaryUps < ActiveRecord::Migration
  def change
    create_table :evaluation_salary_ups do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :evaluation, index: true
      t.float :percent_of_change
      t.float :total_amount
      t.float :total_eligible_amount
      t.float :point_level1
      t.float :point_level2
      t.float :point_level3
      t.float :point_level4
      t.float :point_level5
      t.float :min_change1
      t.float :min_change2
      t.float :min_change3
      t.float :min_change4
      t.float :min_change5
      t.float :max_change1
      t.float :max_change2
      t.float :max_change3
      t.float :max_change4
      t.float :max_change5

      t.userstamps
      t.timestamps
    end
  end
end
