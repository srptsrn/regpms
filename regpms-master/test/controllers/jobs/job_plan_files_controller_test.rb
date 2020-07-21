require 'test_helper'

class Jobs::JobPlanFilesControllerTest < ActionController::TestCase
  setup do
    @job_plan_file = job_plan_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:job_plan_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job_plan_file" do
    assert_difference('JobPlanFile.count') do
      post :create, job_plan_file: { description: @job_plan_file.description, file: @job_plan_file.file, job_plan_id: @job_plan_file.job_plan_id, workflow_state: @job_plan_file.workflow_state, workflow_state_updater_id: @job_plan_file.workflow_state_updater_id }
    end

    assert_redirected_to jobs_job_plan_file_path(assigns(:job_plan_file))
  end

  test "should show job_plan_file" do
    get :show, id: @job_plan_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job_plan_file
    assert_response :success
  end

  test "should update job_plan_file" do
    patch :update, id: @job_plan_file, job_plan_file: { description: @job_plan_file.description, file: @job_plan_file.file, job_plan_id: @job_plan_file.job_plan_id, workflow_state: @job_plan_file.workflow_state, workflow_state_updater_id: @job_plan_file.workflow_state_updater_id }
    assert_redirected_to jobs_job_plan_file_path(assigns(:job_plan_file))
  end

  test "should destroy job_plan_file" do
    assert_difference('JobPlanFile.count', -1) do
      delete :destroy, id: @job_plan_file
    end

    assert_redirected_to jobs_job_plan_files_path
  end
end
