json.array!(@e360_item_users) do |e360_item_user|
  json.extract! e360_item_user, :id, :to_s, :e360_user_id, :e360_item_id, :score
  json.url e360_item_user_url(e360_item_user, format: :json)
end