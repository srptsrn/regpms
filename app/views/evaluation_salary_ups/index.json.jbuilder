json.array!(@evaluation_salary_ups) do |evaluation_salary_up|
  json.extract! evaluation_salary_up, :id, :to_s, :workflow_state, :workflow_state_updater_id, :evaluation_id, :percent_of_change, :total_amount, :total_eligible_amount, :point_level1, :point_level2, :point_level3, :point_level4, :point_level5, :min_change1, :min_change2, :min_change3, :min_change4, :min_change5, :max_change1, :max_change2, :max_change3, :max_change4, :max_change5
  json.url evaluation_salary_up_url(evaluation_salary_up, format: :json)
end