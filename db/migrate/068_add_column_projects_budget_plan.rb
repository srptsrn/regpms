class AddColumnProjectsBudgetPlan < ActiveRecord::Migration
  def change
    add_column :projects, :budget_plan_q1, :float
    add_column :projects, :budget_plan_q2, :float
    add_column :projects, :budget_plan_q3, :float
    add_column :projects, :budget_plan_q4, :float
  end
end
