json.array!(@job_plan_files) do |job_plan_file|
  json.extract! job_plan_file, :id, :to_s, :workflow_state, :workflow_state_updater_id, :job_plan_id, :file, :description
  json.url jobs_job_plan_file_url(job_plan_file, format: :json)
end