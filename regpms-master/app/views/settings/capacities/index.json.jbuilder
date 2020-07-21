json.array!(@capacities) do |capacity|
  json.extract! capacity, :id, :to_s, :workflow_state, :workflow_state_updater_id, :name, :file
  json.url settings_capacity_url(capacity, format: :json)
end