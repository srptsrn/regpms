json.array!(@tactics) do |tactic|
  json.extract! tactic, :id, :to_s, :workflow_state, :workflow_state_updater_id, :sorting, :strategy_id, :name
  json.url settings_tactic_url(tactic, format: :json)
end