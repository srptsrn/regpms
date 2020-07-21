json.array!(@job_routine_results) do |job_routine_result|
  json.extract! job_routine_result, :id, :to_s, :workflow_state, :workflow_state_updater_id, :user_id, :evaluation_id, :job_routine_id, :job_result_template_id, :name, :duration, :expect_qty, :qty, :unit, :description, :approver_id
  json.url jobs_job_routine_result_url(job_routine_result, format: :json)
end