require 'test_helper'

class Settings::SectionUsersControllerTest < ActionController::TestCase
  setup do
    @section_user = section_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:section_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create section_user" do
    assert_difference('SectionUser.count') do
      post :create, section_user: { section_id: @section_user.section_id, user_id: @section_user.user_id, workflow_state: @section_user.workflow_state, workflow_state_updater_id: @section_user.workflow_state_updater_id }
    end

    assert_redirected_to settings_section_user_path(assigns(:section_user))
  end

  test "should show section_user" do
    get :show, id: @section_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @section_user
    assert_response :success
  end

  test "should update section_user" do
    patch :update, id: @section_user, section_user: { section_id: @section_user.section_id, user_id: @section_user.user_id, workflow_state: @section_user.workflow_state, workflow_state_updater_id: @section_user.workflow_state_updater_id }
    assert_redirected_to settings_section_user_path(assigns(:section_user))
  end

  test "should destroy section_user" do
    assert_difference('SectionUser.count', -1) do
      delete :destroy, id: @section_user
    end

    assert_redirected_to settings_section_users_path
  end
end
