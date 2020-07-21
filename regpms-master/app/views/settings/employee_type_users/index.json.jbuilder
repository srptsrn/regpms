json.array!(@employee_type_users) do |employee_type_user|
  json.extract! employee_type_user, :id, :to_s, :workflow_state, :workflow_state_updater_id, :employee_type_id, :user_id, :evaluation_id
  json.url settings_employee_type_user_url(employee_type_user, format: :json)
end