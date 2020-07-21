json.array!(@job_development_result_files) do |job_development_result_file|
  json.extract! job_development_result_file, :id, :to_s, :workflow_state, :workflow_state_updater_id, :job_development_result_id, :file, :description
  json.url jobs_job_development_result_file_url(job_development_result_file, format: :json)
end