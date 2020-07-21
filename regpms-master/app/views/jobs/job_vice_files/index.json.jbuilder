json.array!(@job_vice_files) do |job_vice_file|
  json.extract! job_vice_file, :id, :to_s, :workflow_state, :workflow_state_updater_id, :job_vice_id, :file, :description
  json.url jobs_job_vice_file_url(job_vice_file, format: :json)
end