json.array!(@job_vice_results) do |job_vice_result|
  json.extract! job_vice_result, :id, :to_s, :workflow_state, :workflow_state_updater_id, :user_id, :evaluation_id, :job_vice_id, :job_result_template_id, :name, :duration, :expect_qty, :qty, :unit, :description, :approver_id
  json.url jobs_job_vice_result_url(job_vice_result, format: :json)
end