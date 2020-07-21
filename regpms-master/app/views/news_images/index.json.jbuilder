json.array!(@news_images) do |news_image|
  json.extract! news_image, :id, :to_s, :workflow_state, :workflow_state_updater_id, :image, :published_at
  json.url news_image_url(news_image, format: :json)
end