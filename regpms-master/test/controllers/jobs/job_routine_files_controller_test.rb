require 'test_helper'

class Jobs::JobRoutineFilesControllerTest < ActionController::TestCase
  setup do
    @job_routine_file = job_routine_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:job_routine_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job_routine_file" do
    assert_difference('JobRoutineFile.count') do
      post :create, job_routine_file: { description: @job_routine_file.description, file: @job_routine_file.file, job_routine_id: @job_routine_file.job_routine_id, workflow_state: @job_routine_file.workflow_state, workflow_state_updater_id: @job_routine_file.workflow_state_updater_id }
    end

    assert_redirected_to jobs_job_routine_file_path(assigns(:job_routine_file))
  end

  test "should show job_routine_file" do
    get :show, id: @job_routine_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job_routine_file
    assert_response :success
  end

  test "should update job_routine_file" do
    patch :update, id: @job_routine_file, job_routine_file: { description: @job_routine_file.description, file: @job_routine_file.file, job_routine_id: @job_routine_file.job_routine_id, workflow_state: @job_routine_file.workflow_state, workflow_state_updater_id: @job_routine_file.workflow_state_updater_id }
    assert_redirected_to jobs_job_routine_file_path(assigns(:job_routine_file))
  end

  test "should destroy job_routine_file" do
    assert_difference('JobRoutineFile.count', -1) do
      delete :destroy, id: @job_routine_file
    end

    assert_redirected_to jobs_job_routine_files_path
  end
end
