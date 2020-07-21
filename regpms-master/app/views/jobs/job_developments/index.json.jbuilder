json.array!(@job_developments) do |job_development|
  json.extract! job_development, :id, :to_s, :workflow_state, :workflow_state_updater_id, :user_id, :evaluation_id, :job_template_id, :name, :duration, :expect_qty, :qty, :unit, :description, :approver_id
  json.url jobs_job_development_url(job_development, format: :json)
end