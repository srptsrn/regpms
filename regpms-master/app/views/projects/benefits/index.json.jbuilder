json.array!(@benefits) do |benefit|
  json.extract! benefit, :id, :to_s, :workflow_state, :workflow_state_updater_id, :project_id, :sorting, :description
  json.url projects_benefit_url(benefit, format: :json)
end