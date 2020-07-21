json.array!(@activities) do |activity|
  json.extract! activity, :id, :to_s, :workflow_state, :workflow_state_updater_id, :project_id, :sorting, :name, :from_date, :to_date, :location, :number_of_participant, :description
  json.url projects_activity_url(activity, format: :json)
end