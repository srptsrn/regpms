json.array!(@e360_items) do |e360_item|
  json.extract! e360_item, :id, :to_s, :workflow_state, :workflow_state_updater_id, :evaluation_id, :sorting, :name
  json.url settings_e360_item_url(e360_item, format: :json)
end