require 'test_helper'

class Jobs::JobRoutineResultsControllerTest < ActionController::TestCase
  setup do
    @job_routine_result = job_routine_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:job_routine_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job_routine_result" do
    assert_difference('JobRoutineResult.count') do
      post :create, job_routine_result: { approver_id: @job_routine_result.approver_id, description: @job_routine_result.description, duration: @job_routine_result.duration, evaluation_id: @job_routine_result.evaluation_id, expect_qty: @job_routine_result.expect_qty, job_result_template_id: @job_routine_result.job_result_template_id, job_routine_id: @job_routine_result.job_routine_id, name: @job_routine_result.name, qty: @job_routine_result.qty, unit: @job_routine_result.unit, user_id: @job_routine_result.user_id, workflow_state: @job_routine_result.workflow_state, workflow_state_updater_id: @job_routine_result.workflow_state_updater_id }
    end

    assert_redirected_to jobs_job_routine_result_path(assigns(:job_routine_result))
  end

  test "should show job_routine_result" do
    get :show, id: @job_routine_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job_routine_result
    assert_response :success
  end

  test "should update job_routine_result" do
    patch :update, id: @job_routine_result, job_routine_result: { approver_id: @job_routine_result.approver_id, description: @job_routine_result.description, duration: @job_routine_result.duration, evaluation_id: @job_routine_result.evaluation_id, expect_qty: @job_routine_result.expect_qty, job_result_template_id: @job_routine_result.job_result_template_id, job_routine_id: @job_routine_result.job_routine_id, name: @job_routine_result.name, qty: @job_routine_result.qty, unit: @job_routine_result.unit, user_id: @job_routine_result.user_id, workflow_state: @job_routine_result.workflow_state, workflow_state_updater_id: @job_routine_result.workflow_state_updater_id }
    assert_redirected_to jobs_job_routine_result_path(assigns(:job_routine_result))
  end

  test "should destroy job_routine_result" do
    assert_difference('JobRoutineResult.count', -1) do
      delete :destroy, id: @job_routine_result
    end

    assert_redirected_to jobs_job_routine_results_path
  end
end
