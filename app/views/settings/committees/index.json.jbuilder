json.array!(@committees) do |committee|
  json.extract! committee, :id, :to_s, :workflow_state, :workflow_state_updater_id, :evaluation_id, :user_id
  json.url settings_committee_url(committee, format: :json)
end