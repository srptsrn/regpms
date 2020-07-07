require 'test_helper'

class Settings::FacultyUsersControllerTest < ActionController::TestCase
  setup do
    @faculty_user = faculty_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:faculty_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create faculty_user" do
    assert_difference('FacultyUser.count') do
      post :create, faculty_user: { faculty_id: @faculty_user.faculty_id, user_id: @faculty_user.user_id, workflow_state: @faculty_user.workflow_state, workflow_state_updater_id: @faculty_user.workflow_state_updater_id }
    end

    assert_redirected_to settings_faculty_user_path(assigns(:faculty_user))
  end

  test "should show faculty_user" do
    get :show, id: @faculty_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @faculty_user
    assert_response :success
  end

  test "should update faculty_user" do
    patch :update, id: @faculty_user, faculty_user: { faculty_id: @faculty_user.faculty_id, user_id: @faculty_user.user_id, workflow_state: @faculty_user.workflow_state, workflow_state_updater_id: @faculty_user.workflow_state_updater_id }
    assert_redirected_to settings_faculty_user_path(assigns(:faculty_user))
  end

  test "should destroy faculty_user" do
    assert_difference('FacultyUser.count', -1) do
      delete :destroy, id: @faculty_user
    end

    assert_redirected_to settings_faculty_users_path
  end
end
