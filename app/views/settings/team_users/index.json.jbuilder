json.array!(@team_users) do |team_user|
  json.extract! team_user, :id, :to_s, :workflow_state, :workflow_state_updater_id, :team_id, :user_id
  json.url settings_team_user_url(team_user, format: :json)
end