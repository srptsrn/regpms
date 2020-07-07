require 'test_helper'

class Projects::ProjectImagesControllerTest < ActionController::TestCase
  setup do
    @project_image = project_images(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_image" do
    assert_difference('ProjectImage.count') do
      post :create, project_image: { image: @project_image.image, project_id: @project_image.project_id, workflow_state: @project_image.workflow_state, workflow_state_updater_id: @project_image.workflow_state_updater_id }
    end

    assert_redirected_to projects_project_image_path(assigns(:project_image))
  end

  test "should show project_image" do
    get :show, id: @project_image
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project_image
    assert_response :success
  end

  test "should update project_image" do
    patch :update, id: @project_image, project_image: { image: @project_image.image, project_id: @project_image.project_id, workflow_state: @project_image.workflow_state, workflow_state_updater_id: @project_image.workflow_state_updater_id }
    assert_redirected_to projects_project_image_path(assigns(:project_image))
  end

  test "should destroy project_image" do
    assert_difference('ProjectImage.count', -1) do
      delete :destroy, id: @project_image
    end

    assert_redirected_to projects_project_images_path
  end
end
