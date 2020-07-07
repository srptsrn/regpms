json.array!(@evaluation_principles) do |evaluation_principle|
  json.extract! evaluation_principle, :id, :to_s, :workflow_state, :workflow_state_updater_id, :evaluation_id, :task_id, :principle1, :principle2, :principle3, :principle4, :principle5
  json.url settings_evaluation_principle_url(evaluation_principle, format: :json)
end