json.array!(@objectives) do |objective|
  json.extract! objective, :id, :to_s, :workflow_state, :workflow_state_updater_id, :project_id, :sorting, :description
  json.url projects_objective_url(objective, format: :json)
end