json.array!(@positions) do |position|
  json.extract! position, :id, :to_s, :workflow_state, :workflow_state_updater_id, :name, :position_type_id
  json.url settings_position_url(position, format: :json)
end