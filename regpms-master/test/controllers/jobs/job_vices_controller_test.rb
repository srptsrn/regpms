require 'test_helper'

class Jobs::JobVicesControllerTest < ActionController::TestCase
  setup do
    @job_vice = job_vices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:job_vices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job_vice" do
    assert_difference('JobVice.count') do
      post :create, job_vice: { approver_id: @job_vice.approver_id, description: @job_vice.description, duration: @job_vice.duration, evaluation_id: @job_vice.evaluation_id, expect_qty: @job_vice.expect_qty, job_template_id: @job_vice.job_template_id, name: @job_vice.name, qty: @job_vice.qty, unit: @job_vice.unit, user_id: @job_vice.user_id, workflow_state: @job_vice.workflow_state, workflow_state_updater_id: @job_vice.workflow_state_updater_id }
    end

    assert_redirected_to jobs_job_vice_path(assigns(:job_vice))
  end

  test "should show job_vice" do
    get :show, id: @job_vice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job_vice
    assert_response :success
  end

  test "should update job_vice" do
    patch :update, id: @job_vice, job_vice: { approver_id: @job_vice.approver_id, description: @job_vice.description, duration: @job_vice.duration, evaluation_id: @job_vice.evaluation_id, expect_qty: @job_vice.expect_qty, job_template_id: @job_vice.job_template_id, name: @job_vice.name, qty: @job_vice.qty, unit: @job_vice.unit, user_id: @job_vice.user_id, workflow_state: @job_vice.workflow_state, workflow_state_updater_id: @job_vice.workflow_state_updater_id }
    assert_redirected_to jobs_job_vice_path(assigns(:job_vice))
  end

  test "should destroy job_vice" do
    assert_difference('JobVice.count', -1) do
      delete :destroy, id: @job_vice
    end

    assert_redirected_to jobs_job_vices_path
  end
end
