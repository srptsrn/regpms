json.array!(@budget_groups) do |budget_group|
  json.extract! budget_group, :id, :to_s, :workflow_state, :workflow_state_updater_id, :name
  json.url settings_budget_group_url(budget_group, format: :json)
end