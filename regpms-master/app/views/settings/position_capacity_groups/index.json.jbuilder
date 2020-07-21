json.array!(@position_capacity_groups) do |position_capacity_group|
  json.extract! position_capacity_group, :id, :to_s, :workflow_state, :workflow_state_updater_id, :sorting, :position_id, :name
  json.url settings_position_capacity_group_url(position_capacity_group, format: :json)
end