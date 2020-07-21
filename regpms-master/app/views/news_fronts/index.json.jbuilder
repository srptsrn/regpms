json.array!(@news_fronts) do |news_front|
  json.extract! news_front, :id, :to_s, :workflow_state, :workflow_state_updater_id, :title, :detail, :image, :published_at
  json.url news_front_url(news_front, format: :json)
end