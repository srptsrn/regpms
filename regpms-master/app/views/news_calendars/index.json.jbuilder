json.array!(@news_calendars) do |news_calendar|
  json.extract! news_calendar, :id, :to_s, :workflow_state, :workflow_state_updater_id, :start_at, :end_at, :title, :detail, :published_at
  json.url news_calendar_url(news_calendar, format: :json)
end