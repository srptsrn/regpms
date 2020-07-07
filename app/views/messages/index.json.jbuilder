json.array!(@messages) do |message|
  json.extract! message, :id, :to_s, :message_id, :user_id, :topic, :body, :workflow_state, :workflow_state_updater_id
  json.url message_url(message, format: :json)
end