json.array!(@evaluation_users) do |evaluation_user|
  json.extract! evaluation_user, :id, :to_s, :workflow_state, :workflow_state_updater_id, :user_id, :evaluation_id, :committee_id, :role, :comment1, :comment2, :position_capacity_total, :employee_type_task_total
  json.url evaluation_user_url(evaluation_user, format: :json)
end