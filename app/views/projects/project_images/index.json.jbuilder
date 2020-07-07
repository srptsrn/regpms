json.array!(@project_images) do |project_image|
  json.extract! project_image, :id, :to_s, :workflow_state, :workflow_state_updater_id, :project_id, :image
  json.url projects_project_image_url(project_image, format: :json)
end