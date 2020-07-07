json.array!(@sections) do |section|
  json.extract! section, :id, :to_s, :workflow_state, :workflow_state_updater_id, :name, :leader_id, :vice_leader_id
  json.url settings_section_url(section, format: :json)
end