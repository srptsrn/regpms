json.array!(@position_levels) do |position_level|
  json.extract! position_level, :id, :to_s, :workflow_state, :workflow_state_updater_id, :name, :sorting
  json.url settings_position_level_url(position_level, format: :json)
end