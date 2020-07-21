json.array!(@employee_type_task_users) do |employee_type_task_user|
  json.extract! employee_type_task_user, :id, :to_s, :workflow_state, :workflow_state_updater_id, :employee_type_task_id, :user_id, :evaluation_id, :committee_id, :role, :weight, :score, :score_real
  json.url employee_type_task_user_url(employee_type_task_user, format: :json)
end