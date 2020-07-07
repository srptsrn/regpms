json.array!(@assessments) do |assessment|
  json.extract! assessment, :id, :to_s, :workflow_state, :workflow_state_updater_id, :user_id, :evaluation_id, :committee_id, :role, :score111, :score112, :score113, :score114, :score211, :score212, :score213, :score214, :score215, :score221, :score222, :score223, :score224, :score225, :score226, :comment1, :comment2
  json.url assessment_url(assessment, format: :json)
end