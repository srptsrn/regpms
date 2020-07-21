json.array!(@assessment2s) do |assessment2|
  json.extract! assessment2, :id, :to_s, :workflow_state, :workflow_state_updater_id, :user_id, :evaluation_id, :committee_id, :role, :score111, :score112, :score113, :score114, :score121, :score122, :score123, :score124, :score211, :score212, :score213, :score214, :score215, :score221, :score222, :score223, :score224, :comment1, :comment2
  json.url assessment2_url(assessment2, format: :json)
end