json.array!(@tasks) do |task|
  json.extract! task, :id, :to_s, :workflow_state, :workflow_state_updater_id, :sorting, :name, :file
  json.url settings_task_url(task, format: :json)
end