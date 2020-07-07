json.array!(@base_salaries) do |base_salary|
  json.extract! base_salary, :id, :to_s, :workflow_state, :workflow_state_updater_id, :evaluation_id, :position_level_id, :min_low, :max_low, :base_low, :min_high, :max_high, :base_high, :remark
  json.url settings_base_salary_url(base_salary, format: :json)
end