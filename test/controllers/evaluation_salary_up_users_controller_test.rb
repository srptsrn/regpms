require 'test_helper'

class EvaluationSalaryUpUsersControllerTest < ActionController::TestCase
  setup do
    @evaluation_salary_up_user = evaluation_salary_up_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:evaluation_salary_up_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create evaluation_salary_up_user" do
    assert_difference('EvaluationSalaryUpUser.count') do
      post :create, evaluation_salary_up_user: { base_salary: @evaluation_salary_up_user.base_salary, base_salary_max: @evaluation_salary_up_user.base_salary_max, base_salary_min: @evaluation_salary_up_user.base_salary_min, evaluation_id: @evaluation_salary_up_user.evaluation_id, evaluation_salary_up_id: @evaluation_salary_up_user.evaluation_salary_up_id, is_eligible: @evaluation_salary_up_user.is_eligible, is_work_hour_passed: @evaluation_salary_up_user.is_work_hour_passed, late_count: @evaluation_salary_up_user.late_count, leave_count: @evaluation_salary_up_user.leave_count, lost_count: @evaluation_salary_up_user.lost_count, percent_of_min_up: @evaluation_salary_up_user.percent_of_min_up, percent_of_up: @evaluation_salary_up_user.percent_of_up, point: @evaluation_salary_up_user.point, position_level_id: @evaluation_salary_up_user.position_level_id, salary: @evaluation_salary_up_user.salary, salary_min_up: @evaluation_salary_up_user.salary_min_up, salary_up: @evaluation_salary_up_user.salary_up, user_id: @evaluation_salary_up_user.user_id, workflow_state: @evaluation_salary_up_user.workflow_state, workflow_state_updater_id: @evaluation_salary_up_user.workflow_state_updater_id }
    end

    assert_redirected_to evaluation_salary_up_user_path(assigns(:evaluation_salary_up_user))
  end

  test "should show evaluation_salary_up_user" do
    get :show, id: @evaluation_salary_up_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @evaluation_salary_up_user
    assert_response :success
  end

  test "should update evaluation_salary_up_user" do
    patch :update, id: @evaluation_salary_up_user, evaluation_salary_up_user: { base_salary: @evaluation_salary_up_user.base_salary, base_salary_max: @evaluation_salary_up_user.base_salary_max, base_salary_min: @evaluation_salary_up_user.base_salary_min, evaluation_id: @evaluation_salary_up_user.evaluation_id, evaluation_salary_up_id: @evaluation_salary_up_user.evaluation_salary_up_id, is_eligible: @evaluation_salary_up_user.is_eligible, is_work_hour_passed: @evaluation_salary_up_user.is_work_hour_passed, late_count: @evaluation_salary_up_user.late_count, leave_count: @evaluation_salary_up_user.leave_count, lost_count: @evaluation_salary_up_user.lost_count, percent_of_min_up: @evaluation_salary_up_user.percent_of_min_up, percent_of_up: @evaluation_salary_up_user.percent_of_up, point: @evaluation_salary_up_user.point, position_level_id: @evaluation_salary_up_user.position_level_id, salary: @evaluation_salary_up_user.salary, salary_min_up: @evaluation_salary_up_user.salary_min_up, salary_up: @evaluation_salary_up_user.salary_up, user_id: @evaluation_salary_up_user.user_id, workflow_state: @evaluation_salary_up_user.workflow_state, workflow_state_updater_id: @evaluation_salary_up_user.workflow_state_updater_id }
    assert_redirected_to evaluation_salary_up_user_path(assigns(:evaluation_salary_up_user))
  end

  test "should destroy evaluation_salary_up_user" do
    assert_difference('EvaluationSalaryUpUser.count', -1) do
      delete :destroy, id: @evaluation_salary_up_user
    end

    assert_redirected_to evaluation_salary_up_users_path
  end
end
