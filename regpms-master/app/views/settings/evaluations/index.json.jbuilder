json.array!(@evaluations) do |evaluation|
  json.extract! evaluation, :id, :to_s, :workflow_state, :workflow_state_updater_id, :year, :episode, :pd_start_date, :pd_end_date, :pf_start_date, :pf_end_date, :confirm_start_date, :confirm_end_date, :evaluation_start_date, :evaluation_end_date, :director_id, :vice_director_id, :vice_director2_id, :vice_director3_id, :secretary_id
  json.url settings_evaluation_url(evaluation, format: :json)
end