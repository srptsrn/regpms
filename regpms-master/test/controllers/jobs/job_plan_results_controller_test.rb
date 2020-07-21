require 'test_helper'

class Jobs::JobPlanResultsControllerTest < ActionController::TestCase
  setup do
    @job_plan_result = job_plan_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:job_plan_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job_plan_result" do
    assert_difference('JobPlanResult.count') do
      post :create, job_plan_result: { approver_id: @job_plan_result.approver_id, description: @job_plan_result.description, duration: @job_plan_result.duration, evaluation_id: @job_plan_result.evaluation_id, expect_qty: @job_plan_result.expect_qty, job_plan_id: @job_plan_result.job_plan_id, job_result_template_id: @job_plan_result.job_result_template_id, name: @job_plan_result.name, qty: @job_plan_result.qty, unit: @job_plan_result.unit, user_id: @job_plan_result.user_id, workflow_state: @job_plan_result.workflow_state, workflow_state_updater_id: @job_plan_result.workflow_state_updater_id }
    end

    assert_redirected_to jobs_job_plan_result_path(assigns(:job_plan_result))
  end

  test "should show job_plan_result" do
    get :show, id: @job_plan_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job_plan_result
    assert_response :success
  end

  test "should update job_plan_result" do
    patch :update, id: @job_plan_result, job_plan_result: { approver_id: @job_plan_result.approver_id, description: @job_plan_result.description, duration: @job_plan_result.duration, evaluation_id: @job_plan_result.evaluation_id, expect_qty: @job_plan_result.expect_qty, job_plan_id: @job_plan_result.job_plan_id, job_result_template_id: @job_plan_result.job_result_template_id, name: @job_plan_result.name, qty: @job_plan_result.qty, unit: @job_plan_result.unit, user_id: @job_plan_result.user_id, workflow_state: @job_plan_result.workflow_state, workflow_state_updater_id: @job_plan_result.workflow_state_updater_id }
    assert_redirected_to jobs_job_plan_result_path(assigns(:job_plan_result))
  end

  test "should destroy job_plan_result" do
    assert_difference('JobPlanResult.count', -1) do
      delete :destroy, id: @job_plan_result
    end

    assert_redirected_to jobs_job_plan_results_path
  end
end
