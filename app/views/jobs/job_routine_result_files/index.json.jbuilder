json.array!(@job_routine_result_files) do |job_routine_result_file|
  json.extract! job_routine_result_file, :id, :to_s, :workflow_state, :workflow_state_updater_id, :job_routine_result_id, :file, :description
  json.url jobs_job_routine_result_file_url(job_routine_result_file, format: :json)
end