json.array!(@employee_types) do |employee_type|
  json.extract! employee_type, :id, :to_s, :workflow_state, :workflow_state_updater_id, :name, :sorting
  json.url settings_employee_type_url(employee_type, format: :json)
end