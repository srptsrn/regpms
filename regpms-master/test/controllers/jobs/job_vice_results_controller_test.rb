require 'test_helper'

class Jobs::JobViceResultsControllerTest < ActionController::TestCase
  setup do
    @job_vice_result = job_vice_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:job_vice_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job_vice_result" do
    assert_difference('JobViceResult.count') do
      post :create, job_vice_result: { approver_id: @job_vice_result.approver_id, description: @job_vice_result.description, duration: @job_vice_result.duration, evaluation_id: @job_vice_result.evaluation_id, expect_qty: @job_vice_result.expect_qty, job_result_template_id: @job_vice_result.job_result_template_id, job_vice_id: @job_vice_result.job_vice_id, name: @job_vice_result.name, qty: @job_vice_result.qty, unit: @job_vice_result.unit, user_id: @job_vice_result.user_id, workflow_state: @job_vice_result.workflow_state, workflow_state_updater_id: @job_vice_result.workflow_state_updater_id }
    end

    assert_redirected_to jobs_job_vice_result_path(assigns(:job_vice_result))
  end

  test "should show job_vice_result" do
    get :show, id: @job_vice_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job_vice_result
    assert_response :success
  end

  test "should update job_vice_result" do
    patch :update, id: @job_vice_result, job_vice_result: { approver_id: @job_vice_result.approver_id, description: @job_vice_result.description, duration: @job_vice_result.duration, evaluation_id: @job_vice_result.evaluation_id, expect_qty: @job_vice_result.expect_qty, job_result_template_id: @job_vice_result.job_result_template_id, job_vice_id: @job_vice_result.job_vice_id, name: @job_vice_result.name, qty: @job_vice_result.qty, unit: @job_vice_result.unit, user_id: @job_vice_result.user_id, workflow_state: @job_vice_result.workflow_state, workflow_state_updater_id: @job_vice_result.workflow_state_updater_id }
    assert_redirected_to jobs_job_vice_result_path(assigns(:job_vice_result))
  end

  test "should destroy job_vice_result" do
    assert_difference('JobViceResult.count', -1) do
      delete :destroy, id: @job_vice_result
    end

    assert_redirected_to jobs_job_vice_results_path
  end
end
