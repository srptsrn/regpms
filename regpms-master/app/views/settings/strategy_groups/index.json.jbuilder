json.array!(@strategy_groups) do |strategy_group|
  json.extract! strategy_group, :id, :to_s, :workflow_state, :workflow_state_updater_id, :no, :name
  json.url settings_strategy_group_url(strategy_group, format: :json)
end