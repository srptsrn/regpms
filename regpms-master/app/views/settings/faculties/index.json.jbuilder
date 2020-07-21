json.array!(@faculties) do |faculty|
  json.extract! faculty, :id, :to_s, :workflow_state, :workflow_state_updater_id, :name, :dean_id, :leader_id
  json.url settings_faculty_url(faculty, format: :json)
end