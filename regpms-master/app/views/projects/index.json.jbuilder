json.array!(@projects) do |project|
  json.extract! project, :id, :to_s, :workflow_state, :workflow_state_updater_id, :code, :name, :policy_id, :rationale, :objective, :from_date, :to_date, :budget_amount
  json.url project_url(project, format: :json)
end