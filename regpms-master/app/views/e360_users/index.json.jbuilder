json.array!(@e360_users) do |e360_user|
  json.extract! e360_user, :id, :to_s, :workflow_state, :workflow_state_updater_id, :evaluation_id, :user_id, :committee_id, :role
  json.url e360_user_url(e360_user, format: :json)
end