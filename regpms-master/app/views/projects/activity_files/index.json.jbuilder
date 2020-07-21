json.array!(@activity_files) do |activity_file|
  json.extract! activity_file, :id, :to_s, :workflow_state, :workflow_state_updater_id, :activity_id, :file
  json.url projects_activity_file_url(activity_file, format: :json)
end