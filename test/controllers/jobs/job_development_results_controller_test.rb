require 'test_helper'

class Jobs::JobDevelopmentResultsControllerTest < ActionController::TestCase
  setup do
    @job_development_result = job_development_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:job_development_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job_development_result" do
    assert_difference('JobDevelopmentResult.count') do
      post :create, job_development_result: { approver_id: @job_development_result.approver_id, description: @job_development_result.description, duration: @job_development_result.duration, evaluation_id: @job_development_result.evaluation_id, expect_qty: @job_development_result.expect_qty, job_development_id: @job_development_result.job_development_id, job_result_template_id: @job_development_result.job_result_template_id, name: @job_development_result.name, qty: @job_development_result.qty, unit: @job_development_result.unit, user_id: @job_development_result.user_id, workflow_state: @job_development_result.workflow_state, workflow_state_updater_id: @job_development_result.workflow_state_updater_id }
    end

    assert_redirected_to jobs_job_development_result_path(assigns(:job_development_result))
  end

  test "should show job_development_result" do
    get :show, id: @job_development_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job_development_result
    assert_response :success
  end

  test "should update job_development_result" do
    patch :update, id: @job_development_result, job_development_result: { approver_id: @job_development_result.approver_id, description: @job_development_result.description, duration: @job_development_result.duration, evaluation_id: @job_development_result.evaluation_id, expect_qty: @job_development_result.expect_qty, job_development_id: @job_development_result.job_development_id, job_result_template_id: @job_development_result.job_result_template_id, name: @job_development_result.name, qty: @job_development_result.qty, unit: @job_development_result.unit, user_id: @job_development_result.user_id, workflow_state: @job_development_result.workflow_state, workflow_state_updater_id: @job_development_result.workflow_state_updater_id }
    assert_redirected_to jobs_job_development_result_path(assigns(:job_development_result))
  end

  test "should destroy job_development_result" do
    assert_difference('JobDevelopmentResult.count', -1) do
      delete :destroy, id: @job_development_result
    end

    assert_redirected_to jobs_job_development_results_path
  end
end
