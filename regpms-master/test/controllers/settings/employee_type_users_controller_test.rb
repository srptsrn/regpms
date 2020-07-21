require 'test_helper'

class Settings::EmployeeTypeUsersControllerTest < ActionController::TestCase
  setup do
    @employee_type_user = employee_type_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:employee_type_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create employee_type_user" do
    assert_difference('EmployeeTypeUser.count') do
      post :create, employee_type_user: { employee_type_id: @employee_type_user.employee_type_id, evaluation_id: @employee_type_user.evaluation_id, user_id: @employee_type_user.user_id, workflow_state: @employee_type_user.workflow_state, workflow_state_updater_id: @employee_type_user.workflow_state_updater_id }
    end

    assert_redirected_to settings_employee_type_user_path(assigns(:employee_type_user))
  end

  test "should show employee_type_user" do
    get :show, id: @employee_type_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @employee_type_user
    assert_response :success
  end

  test "should update employee_type_user" do
    patch :update, id: @employee_type_user, employee_type_user: { employee_type_id: @employee_type_user.employee_type_id, evaluation_id: @employee_type_user.evaluation_id, user_id: @employee_type_user.user_id, workflow_state: @employee_type_user.workflow_state, workflow_state_updater_id: @employee_type_user.workflow_state_updater_id }
    assert_redirected_to settings_employee_type_user_path(assigns(:employee_type_user))
  end

  test "should destroy employee_type_user" do
    assert_difference('EmployeeTypeUser.count', -1) do
      delete :destroy, id: @employee_type_user
    end

    assert_redirected_to settings_employee_type_users_path
  end
end
