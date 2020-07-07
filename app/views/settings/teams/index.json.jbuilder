json.array!(@teams) do |team|
  json.extract! team, :id, :to_s, :workflow_state, :workflow_state_updater_id, :name, :leader_id
  json.url settings_team_url(team, format: :json)
end