require 'test_helper'

class Projects::ActivityFilesControllerTest < ActionController::TestCase
  setup do
    @activity_file = activity_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:activity_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create activity_file" do
    assert_difference('ActivityFile.count') do
      post :create, activity_file: { activity_id: @activity_file.activity_id, file: @activity_file.file, workflow_state: @activity_file.workflow_state, workflow_state_updater_id: @activity_file.workflow_state_updater_id }
    end

    assert_redirected_to projects_activity_file_path(assigns(:activity_file))
  end

  test "should show activity_file" do
    get :show, id: @activity_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @activity_file
    assert_response :success
  end

  test "should update activity_file" do
    patch :update, id: @activity_file, activity_file: { activity_id: @activity_file.activity_id, file: @activity_file.file, workflow_state: @activity_file.workflow_state, workflow_state_updater_id: @activity_file.workflow_state_updater_id }
    assert_redirected_to projects_activity_file_path(assigns(:activity_file))
  end

  test "should destroy activity_file" do
    assert_difference('ActivityFile.count', -1) do
      delete :destroy, id: @activity_file
    end

    assert_redirected_to projects_activity_files_path
  end
end
