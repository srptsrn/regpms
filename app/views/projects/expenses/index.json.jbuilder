json.array!(@expenses) do |expense|
  json.extract! expense, :id, :to_s, :workflow_state, :workflow_state_updater_id, :project_id, :sorting, :budget_type_id, :date, :description, :amount, :by
  json.url projects_expense_url(expense, format: :json)
end