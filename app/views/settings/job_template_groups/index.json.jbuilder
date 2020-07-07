json.array!(@job_template_groups) do |job_template_group|
  json.extract! job_template_group, :id, :to_s, :workflow_state, :workflow_state_updater_id, :name, :sorting
  json.url settings_job_template_group_url(job_template_group, format: :json)
end