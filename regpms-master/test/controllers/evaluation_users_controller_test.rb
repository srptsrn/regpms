require 'test_helper'

class EvaluationUsersControllerTest < ActionController::TestCase
  setup do
    @evaluation_user = evaluation_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:evaluation_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create evaluation_user" do
    assert_difference('EvaluationUser.count') do
      post :create, evaluation_user: { comment1: @evaluation_user.comment1, comment2: @evaluation_user.comment2, committee_id: @evaluation_user.committee_id, employee_type_task_total: @evaluation_user.employee_type_task_total, evaluation_id: @evaluation_user.evaluation_id, position_capacity_total: @evaluation_user.position_capacity_total, role: @evaluation_user.role, user_id: @evaluation_user.user_id, workflow_state: @evaluation_user.workflow_state, workflow_state_updater_id: @evaluation_user.workflow_state_updater_id }
    end

    assert_redirected_to evaluation_user_path(assigns(:evaluation_user))
  end

  test "should show evaluation_user" do
    get :show, id: @evaluation_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @evaluation_user
    assert_response :success
  end

  test "should update evaluation_user" do
    patch :update, id: @evaluation_user, evaluation_user: { comment1: @evaluation_user.comment1, comment2: @evaluation_user.comment2, committee_id: @evaluation_user.committee_id, employee_type_task_total: @evaluation_user.employee_type_task_total, evaluation_id: @evaluation_user.evaluation_id, position_capacity_total: @evaluation_user.position_capacity_total, role: @evaluation_user.role, user_id: @evaluation_user.user_id, workflow_state: @evaluation_user.workflow_state, workflow_state_updater_id: @evaluation_user.workflow_state_updater_id }
    assert_redirected_to evaluation_user_path(assigns(:evaluation_user))
  end

  test "should destroy evaluation_user" do
    assert_difference('EvaluationUser.count', -1) do
      delete :destroy, id: @evaluation_user
    end

    assert_redirected_to evaluation_users_path
  end
end
