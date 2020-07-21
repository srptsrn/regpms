json.array!(@kku_strategic_pillars) do |kku_strategic_pillar|
  json.extract! kku_strategic_pillar, :id, :to_s, :workflow_state, :workflow_state_updater_id, :no, :name
  json.url settings_kku_strategic_pillar_url(kku_strategic_pillar, format: :json)
end