json.array!(@budgets) do |budget|
  json.extract! budget, :id, :to_s, :workflow_state, :workflow_state_updater_id, :project_id, :sorting, :budget_type_id, :description, :amount
  json.url projects_budget_url(budget, format: :json)
end