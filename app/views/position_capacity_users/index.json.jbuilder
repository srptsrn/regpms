json.array!(@position_capacity_users) do |position_capacity_user|
  json.extract! position_capacity_user, :id, :to_s, :workflow_state, :workflow_state_updater_id, :position_capacity_id, :user_id, :evaluation_id, :committee_id, :role, :expect, :weight, :score, :score_real_expect, :score_real_100, :score_weight, :score_real
  json.url position_capacity_user_url(position_capacity_user, format: :json)
end