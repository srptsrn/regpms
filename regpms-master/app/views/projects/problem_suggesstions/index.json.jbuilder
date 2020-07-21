json.array!(@problem_suggesstions) do |problem_suggesstion|
  json.extract! problem_suggesstion, :id, :to_s, :workflow_state, :workflow_state_updater_id, :project_id, :sorting, :description
  json.url projects_problem_suggesstion_url(problem_suggesstion, format: :json)
end