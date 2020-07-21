json.array!(@job_result_templates) do |job_result_template|
  json.extract! job_result_template, :id, :to_s, :workflow_state, :workflow_state_updater_id, :job_template_id, :name, :unit, :duration
  json.url settings_job_result_template_url(job_result_template, format: :json)
end