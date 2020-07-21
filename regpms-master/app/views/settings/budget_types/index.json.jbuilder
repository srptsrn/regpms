json.array!(@budget_types) do |budget_type|
  json.extract! budget_type, :id, :to_s, :workflow_state, :workflow_state_updater_id, :name
  json.url settings_budget_type_url(budget_type, format: :json)
end