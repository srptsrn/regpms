json.array!(@employee_type_task_groups) do |employee_type_task_group|
  json.extract! employee_type_task_group, :id, :to_s, :workflow_state, :workflow_state_updater_id, :sorting, :employee_type_id, :name
  json.url settings_employee_type_task_group_url(employee_type_task_group, format: :json)
end