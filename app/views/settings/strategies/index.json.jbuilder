json.array!(@strategies) do |strategy|
  json.extract! strategy, :id, :to_s, :workflow_state, :workflow_state_updater_id, :sorting, :name
  json.url settings_strategy_url(strategy, format: :json)
end