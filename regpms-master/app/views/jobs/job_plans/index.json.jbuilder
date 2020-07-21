json.array!(@job_plans) do |job_plan|
  json.extract! job_plan, :id, :to_s, :workflow_state, :workflow_state_updater_id, :user_id, :evaluation_id, :job_template_id, :name, :duration, :expect_qty, :qty, :unit, :description, :approver_id
  json.url jobs_job_plan_url(job_plan, format: :json)
end