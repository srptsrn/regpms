json.array!(@measures) do |measure|
  json.extract! measure, :id, :to_s, :workflow_state, :workflow_state_updater_id, :tactic_id, :no, :name
  json.url settings_measure_url(measure, format: :json)
end