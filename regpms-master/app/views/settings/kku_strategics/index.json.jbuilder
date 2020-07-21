json.array!(@kku_strategics) do |kku_strategic|
  json.extract! kku_strategic, :id, :to_s, :workflow_state, :workflow_state_updater_id, :kku_strategic_pillar_id, :no, :name
  json.url settings_kku_strategic_url(kku_strategic, format: :json)
end