class CreateEvaluationEmployeeTypes < ActiveRecord::Migration
  def change
    create_table :evaluation_employee_types do |t|
      t.string :workflow_state
      t.references :workflow_state_updater, index: true
      t.references :employee_type, index: true
      t.references :evaluation, index: true
      t.float :leader_ratio
      t.float :committee_ratio
      t.float :task_ratio
      t.float :ability_ratio

      t.userstamps
      t.timestamps
    end
  end
end
