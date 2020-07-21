json.array!(@employee_type_tasks) do |employee_type_task|
  json.extract! employee_type_task, :id, :to_s, :workflow_state, :workflow_state_updater_id, :sorting, :employee_type_task_group_id, :task_id, :weight
  json.url settings_employee_type_task_url(employee_type_task, format: :json)
end