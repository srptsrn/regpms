json.array!(@indicators) do |indicator|
  json.extract! indicator, :id, :to_s, :workflow_state, :workflow_state_updater_id, :project_id, :sorting, :description, :target, :result1, :result2, :result3
  json.url projects_indicator_url(indicator, format: :json)
end