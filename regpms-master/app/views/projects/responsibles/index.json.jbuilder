json.array!(@responsibles) do |responsible|
  json.extract! responsible, :id, :to_s, :workflow_state, :workflow_state_updater_id, :project_id, :sorting, :user_id, :prefix, :firstname, :lastname, :position
  json.url projects_responsible_url(responsible, format: :json)
end