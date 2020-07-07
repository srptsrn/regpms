json.array!(@evaluation_employee_types) do |evaluation_employee_type|
  json.extract! evaluation_employee_type, :id, :to_s, :workflow_state, :workflow_state_updater_id, :employee_type_id, :evaluation_id, :leader_ratio, :committee_ratio, :task_ratio, :ability_ratio
  json.url settings_evaluation_employee_type_url(evaluation_employee_type, format: :json)
end