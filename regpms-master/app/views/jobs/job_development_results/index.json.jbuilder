json.array!(@job_development_results) do |job_development_result|
  json.extract! job_development_result, :id, :to_s, :workflow_state, :workflow_state_updater_id, :user_id, :evaluation_id, :job_development_id, :job_result_template_id, :name, :duration, :expect_qty, :qty, :unit, :description, :approver_id
  json.url jobs_job_development_result_url(job_development_result, format: :json)
end