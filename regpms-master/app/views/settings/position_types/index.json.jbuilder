json.array!(@position_types) do |position_type|
  json.extract! position_type, :id, :to_s, :workflow_state, :workflow_state_updater_id, :name, :sorting
  json.url settings_position_type_url(position_type, format: :json)
end