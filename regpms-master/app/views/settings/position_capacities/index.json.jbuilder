json.array!(@position_capacities) do |position_capacity|
  json.extract! position_capacity, :id, :to_s, :workflow_state, :workflow_state_updater_id, :sorting, :position_capacity_group_id, :capacity_id, :weight, :expect
  json.url settings_position_capacity_url(position_capacity, format: :json)
end