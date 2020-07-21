json.array!(@job_templates) do |job_template|
  json.extract! job_template, :id, :to_s, :workflow_state, :workflow_state_updater_id, :job_template_group_id, :name, :unit, :duration, :is_job_routine, :is_job_vice, :is_job_development
  json.url settings_job_template_url(job_template, format: :json)
end