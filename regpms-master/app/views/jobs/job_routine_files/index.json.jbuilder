json.array!(@job_routine_files) do |job_routine_file|
  json.extract! job_routine_file, :id, :to_s, :workflow_state, :workflow_state_updater_id, :job_routine_id, :file, :description
  json.url jobs_job_routine_file_url(job_routine_file, format: :json)
end