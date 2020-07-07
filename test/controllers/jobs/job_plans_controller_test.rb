require 'test_helper'

class Jobs::JobPlansControllerTest < ActionController::TestCase
  setup do
    @job_plan = job_plans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:job_plans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job_plan" do
    assert_difference('JobPlan.count') do
      post :create, job_plan: { approver_id: @job_plan.approver_id, description: @job_plan.description, duration: @job_plan.duration, evaluation_id: @job_plan.evaluation_id, expect_qty: @job_plan.expect_qty, job_template_id: @job_plan.job_template_id, name: @job_plan.name, qty: @job_plan.qty, unit: @job_plan.unit, user_id: @job_plan.user_id, workflow_state: @job_plan.workflow_state, workflow_state_updater_id: @job_plan.workflow_state_updater_id }
    end

    assert_redirected_to jobs_job_plan_path(assigns(:job_plan))
  end

  test "should show job_plan" do
    get :show, id: @job_plan
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job_plan
    assert_response :success
  end

  test "should update job_plan" do
    patch :update, id: @job_plan, job_plan: { approver_id: @job_plan.approver_id, description: @job_plan.description, duration: @job_plan.duration, evaluation_id: @job_plan.evaluation_id, expect_qty: @job_plan.expect_qty, job_template_id: @job_plan.job_template_id, name: @job_plan.name, qty: @job_plan.qty, unit: @job_plan.unit, user_id: @job_plan.user_id, workflow_state: @job_plan.workflow_state, workflow_state_updater_id: @job_plan.workflow_state_updater_id }
    assert_redirected_to jobs_job_plan_path(assigns(:job_plan))
  end

  test "should destroy job_plan" do
    assert_difference('JobPlan.count', -1) do
      delete :destroy, id: @job_plan
    end

    assert_redirected_to jobs_job_plans_path
  end
end
