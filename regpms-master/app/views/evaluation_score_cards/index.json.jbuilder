json.array!(@evaluation_score_cards) do |evaluation_score_card|
  json.extract! evaluation_score_card, :id, :to_s, :workflow_state, :workflow_state_updater_id, :evaluation_id, :user_id, :committee_id, :role, :task_score, :ability_score
  json.url evaluation_score_card_url(evaluation_score_card, format: :json)
end