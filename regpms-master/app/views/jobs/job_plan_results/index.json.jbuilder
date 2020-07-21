json.array!(@job_plan_results) do |job_plan_result|
  json.extract! job_plan_result, :id, :to_s, :workflow_state, :workflow_state_updater_id, :user_id, :evaluation_id, :job_plan_id, :job_result_template_id, :name, :duration, :expect_qty, :qty, :unit, :description, :approver_id
  json.url jobs_job_plan_result_url(job_plan_result, format: :json)
end