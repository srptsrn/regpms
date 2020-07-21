json.array!(@job_routines) do |job_routine|
  json.extract! job_routine, :id, :to_s, :workflow_state, :workflow_state_updater_id, :user_id, :evaluation_id, :job_template_id, :name, :duration, :expect_qty, :qty, :unit, :description, :approver_id
  json.url jobs_job_routine_url(job_routine, format: :json)
end