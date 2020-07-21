json.array!(@job_development_files) do |job_development_file|
  json.extract! job_development_file, :id, :to_s, :workflow_state, :workflow_state_updater_id, :job_development_id, :file, :description
  json.url jobs_job_development_file_url(job_development_file, format: :json)
end