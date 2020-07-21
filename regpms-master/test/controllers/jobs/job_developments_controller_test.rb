require 'test_helper'

class Jobs::JobDevelopmentsControllerTest < ActionController::TestCase
  setup do
    @job_development = job_developments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:job_developments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job_development" do
    assert_difference('JobDevelopment.count') do
      post :create, job_development: { approver_id: @job_development.approver_id, description: @job_development.description, duration: @job_development.duration, evaluation_id: @job_development.evaluation_id, expect_qty: @job_development.expect_qty, job_template_id: @job_development.job_template_id, name: @job_development.name, qty: @job_development.qty, unit: @job_development.unit, user_id: @job_development.user_id, workflow_state: @job_development.workflow_state, workflow_state_updater_id: @job_development.workflow_state_updater_id }
    end

    assert_redirected_to jobs_job_development_path(assigns(:job_development))
  end

  test "should show job_development" do
    get :show, id: @job_development
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job_development
    assert_response :success
  end

  test "should update job_development" do
    patch :update, id: @job_development, job_development: { approver_id: @job_development.approver_id, description: @job_development.description, duration: @job_development.duration, evaluation_id: @job_development.evaluation_id, expect_qty: @job_development.expect_qty, job_template_id: @job_development.job_template_id, name: @job_development.name, qty: @job_development.qty, unit: @job_development.unit, user_id: @job_development.user_id, workflow_state: @job_development.workflow_state, workflow_state_updater_id: @job_development.workflow_state_updater_id }
    assert_redirected_to jobs_job_development_path(assigns(:job_development))
  end

  test "should destroy job_development" do
    assert_difference('JobDevelopment.count', -1) do
      delete :destroy, id: @job_development
    end

    assert_redirected_to jobs_job_developments_path
  end
end
