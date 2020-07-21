json.array!(@job_plan_result_files) do |job_plan_result_file|
  json.extract! job_plan_result_file, :id, :to_s, :workflow_state, :workflow_state_updater_id, :job_plan_result_id, :file, :description
  json.url jobs_job_plan_result_file_url(job_plan_result_file, format: :json)
end