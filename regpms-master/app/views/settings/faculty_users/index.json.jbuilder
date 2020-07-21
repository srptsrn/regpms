json.array!(@faculty_users) do |faculty_user|
  json.extract! faculty_user, :id, :to_s, :workflow_state, :workflow_state_updater_id, :faculty_id, :user_id
  json.url settings_faculty_user_url(faculty_user, format: :json)
end