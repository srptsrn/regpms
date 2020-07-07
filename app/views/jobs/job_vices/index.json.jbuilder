json.array!(@job_vices) do |job_vice|
  json.extract! job_vice, :id, :to_s, :workflow_state, :workflow_state_updater_id, :user_id, :evaluation_id, :job_template_id, :name, :duration, :expect_qty, :qty, :unit, :description, :approver_id
  json.url jobs_job_vice_url(job_vice, format: :json)
end