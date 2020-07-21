require 'test_helper'

class Jobs::JobViceFilesControllerTest < ActionController::TestCase
  setup do
    @job_vice_file = job_vice_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:job_vice_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job_vice_file" do
    assert_difference('JobViceFile.count') do
      post :create, job_vice_file: { description: @job_vice_file.description, file: @job_vice_file.file, job_vice_id: @job_vice_file.job_vice_id, workflow_state: @job_vice_file.workflow_state, workflow_state_updater_id: @job_vice_file.workflow_state_updater_id }
    end

    assert_redirected_to jobs_job_vice_file_path(assigns(:job_vice_file))
  end

  test "should show job_vice_file" do
    get :show, id: @job_vice_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job_vice_file
    assert_response :success
  end

  test "should update job_vice_file" do
    patch :update, id: @job_vice_file, job_vice_file: { description: @job_vice_file.description, file: @job_vice_file.file, job_vice_id: @job_vice_file.job_vice_id, workflow_state: @job_vice_file.workflow_state, workflow_state_updater_id: @job_vice_file.workflow_state_updater_id }
    assert_redirected_to jobs_job_vice_file_path(assigns(:job_vice_file))
  end

  test "should destroy job_vice_file" do
    assert_difference('JobViceFile.count', -1) do
      delete :destroy, id: @job_vice_file
    end

    assert_redirected_to jobs_job_vice_files_path
  end
end
