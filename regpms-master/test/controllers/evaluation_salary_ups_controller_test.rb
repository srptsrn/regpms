require 'test_helper'

class EvaluationSalaryUpsControllerTest < ActionController::TestCase
  setup do
    @evaluation_salary_up = evaluation_salary_ups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:evaluation_salary_ups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create evaluation_salary_up" do
    assert_difference('EvaluationSalaryUp.count') do
      post :create, evaluation_salary_up: { evaluation_id: @evaluation_salary_up.evaluation_id, max_change1: @evaluation_salary_up.max_change1, max_change2: @evaluation_salary_up.max_change2, max_change3: @evaluation_salary_up.max_change3, max_change4: @evaluation_salary_up.max_change4, max_change5: @evaluation_salary_up.max_change5, min_change1: @evaluation_salary_up.min_change1, min_change2: @evaluation_salary_up.min_change2, min_change3: @evaluation_salary_up.min_change3, min_change4: @evaluation_salary_up.min_change4, min_change5: @evaluation_salary_up.min_change5, percent_of_change: @evaluation_salary_up.percent_of_change, point_level1: @evaluation_salary_up.point_level1, point_level2: @evaluation_salary_up.point_level2, point_level3: @evaluation_salary_up.point_level3, point_level4: @evaluation_salary_up.point_level4, point_level5: @evaluation_salary_up.point_level5, total_amount: @evaluation_salary_up.total_amount, total_eligible_amount: @evaluation_salary_up.total_eligible_amount, workflow_state: @evaluation_salary_up.workflow_state, workflow_state_updater_id: @evaluation_salary_up.workflow_state_updater_id }
    end

    assert_redirected_to evaluation_salary_up_path(assigns(:evaluation_salary_up))
  end

  test "should show evaluation_salary_up" do
    get :show, id: @evaluation_salary_up
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @evaluation_salary_up
    assert_response :success
  end

  test "should update evaluation_salary_up" do
    patch :update, id: @evaluation_salary_up, evaluation_salary_up: { evaluation_id: @evaluation_salary_up.evaluation_id, max_change1: @evaluation_salary_up.max_change1, max_change2: @evaluation_salary_up.max_change2, max_change3: @evaluation_salary_up.max_change3, max_change4: @evaluation_salary_up.max_change4, max_change5: @evaluation_salary_up.max_change5, min_change1: @evaluation_salary_up.min_change1, min_change2: @evaluation_salary_up.min_change2, min_change3: @evaluation_salary_up.min_change3, min_change4: @evaluation_salary_up.min_change4, min_change5: @evaluation_salary_up.min_change5, percent_of_change: @evaluation_salary_up.percent_of_change, point_level1: @evaluation_salary_up.point_level1, point_level2: @evaluation_salary_up.point_level2, point_level3: @evaluation_salary_up.point_level3, point_level4: @evaluation_salary_up.point_level4, point_level5: @evaluation_salary_up.point_level5, total_amount: @evaluation_salary_up.total_amount, total_eligible_amount: @evaluation_salary_up.total_eligible_amount, workflow_state: @evaluation_salary_up.workflow_state, workflow_state_updater_id: @evaluation_salary_up.workflow_state_updater_id }
    assert_redirected_to evaluation_salary_up_path(assigns(:evaluation_salary_up))
  end

  test "should destroy evaluation_salary_up" do
    assert_difference('EvaluationSalaryUp.count', -1) do
      delete :destroy, id: @evaluation_salary_up
    end

    assert_redirected_to evaluation_salary_ups_path
  end
end
