json.array!(@policies) do |policy|
  json.extract! policy, :id, :to_s, :workflow_state, :workflow_state_updater_id, :policy_id, :code, :name
  json.url settings_policy_url(policy, format: :json)
end