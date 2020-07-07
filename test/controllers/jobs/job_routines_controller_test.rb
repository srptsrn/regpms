require 'test_helper'

class Jobs::JobRoutinesControllerTest < ActionController::TestCase
  setup do
    @job_routine = job_routines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:job_routines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job_routine" do
    assert_difference('JobRoutine.count') do
      post :create, job_routine: { approver_id: @job_routine.approver_id, description: @job_routine.description, duration: @job_routine.duration, evaluation_id: @job_routine.evaluation_id, expect_qty: @job_routine.expect_qty, job_template_id: @job_routine.job_template_id, name: @job_routine.name, qty: @job_routine.qty, unit: @job_routine.unit, user_id: @job_routine.user_id, workflow_state: @job_routine.workflow_state, workflow_state_updater_id: @job_routine.workflow_state_updater_id }
    end

    assert_redirected_to jobs_job_routine_path(assigns(:job_routine))
  end

  test "should show job_routine" do
    get :show, id: @job_routine
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job_routine
    assert_response :success
  end

  test "should update job_routine" do
    patch :update, id: @job_routine, job_routine: { approver_id: @job_routine.approver_id, description: @job_routine.description, duration: @job_routine.duration, evaluation_id: @job_routine.evaluation_id, expect_qty: @job_routine.expect_qty, job_template_id: @job_routine.job_template_id, name: @job_routine.name, qty: @job_routine.qty, unit: @job_routine.unit, user_id: @job_routine.user_id, workflow_state: @job_routine.workflow_state, workflow_state_updater_id: @job_routine.workflow_state_updater_id }
    assert_redirected_to jobs_job_routine_path(assigns(:job_routine))
  end

  test "should destroy job_routine" do
    assert_difference('JobRoutine.count', -1) do
      delete :destroy, id: @job_routine
    end

    assert_redirected_to jobs_job_routines_path
  end
end
