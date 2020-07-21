require 'test_helper'

class EmployeeTypeTaskUsersControllerTest < ActionController::TestCase
  setup do
    @employee_type_task_user = employee_type_task_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:employee_type_task_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create employee_type_task_user" do
    assert_difference('EmployeeTypeTaskUser.count') do
      post :create, employee_type_task_user: { committee_id: @employee_type_task_user.committee_id, employee_type_task_id: @employee_type_task_user.employee_type_task_id, evaluation_id: @employee_type_task_user.evaluation_id, role: @employee_type_task_user.role, score: @employee_type_task_user.score, score_real: @employee_type_task_user.score_real, user_id: @employee_type_task_user.user_id, weight: @employee_type_task_user.weight, workflow_state: @employee_type_task_user.workflow_state, workflow_state_updater_id: @employee_type_task_user.workflow_state_updater_id }
    end

    assert_redirected_to employee_type_task_user_path(assigns(:employee_type_task_user))
  end

  test "should show employee_type_task_user" do
    get :show, id: @employee_type_task_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @employee_type_task_user
    assert_response :success
  end

  test "should update employee_type_task_user" do
    patch :update, id: @employee_type_task_user, employee_type_task_user: { committee_id: @employee_type_task_user.committee_id, employee_type_task_id: @employee_type_task_user.employee_type_task_id, evaluation_id: @employee_type_task_user.evaluation_id, role: @employee_type_task_user.role, score: @employee_type_task_user.score, score_real: @employee_type_task_user.score_real, user_id: @employee_type_task_user.user_id, weight: @employee_type_task_user.weight, workflow_state: @employee_type_task_user.workflow_state, workflow_state_updater_id: @employee_type_task_user.workflow_state_updater_id }
    assert_redirected_to employee_type_task_user_path(assigns(:employee_type_task_user))
  end

  test "should destroy employee_type_task_user" do
    assert_difference('EmployeeTypeTaskUser.count', -1) do
      delete :destroy, id: @employee_type_task_user
    end

    assert_redirected_to employee_type_task_users_path
  end
end
