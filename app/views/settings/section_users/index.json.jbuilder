json.array!(@section_users) do |section_user|
  json.extract! section_user, :id, :to_s, :workflow_state, :workflow_state_updater_id, :section_id, :user_id
  json.url settings_section_user_url(section_user, format: :json)
end