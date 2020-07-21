require 'test_helper'

class Jobs::JobDevelopmentResultFilesControllerTest < ActionController::TestCase
  setup do
    @job_development_result_file = job_development_result_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:job_development_result_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job_development_result_file" do
    assert_difference('JobDevelopmentResultFile.count') do
      post :create, job_development_result_file: { description: @job_development_result_file.description, file: @job_development_result_file.file, job_development_result_id: @job_development_result_file.job_development_result_id, workflow_state: @job_development_result_file.workflow_state, workflow_state_updater_id: @job_development_result_file.workflow_state_updater_id }
    end

    assert_redirected_to jobs_job_development_result_file_path(assigns(:job_development_result_file))
  end

  test "should show job_development_result_file" do
    get :show, id: @job_development_result_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job_development_result_file
    assert_response :success
  end

  test "should update job_development_result_file" do
    patch :update, id: @job_development_result_file, job_development_result_file: { description: @job_development_result_file.description, file: @job_development_result_file.file, job_development_result_id: @job_development_result_file.job_development_result_id, workflow_state: @job_development_result_file.workflow_state, workflow_state_updater_id: @job_development_result_file.workflow_state_updater_id }
    assert_redirected_to jobs_job_development_result_file_path(assigns(:job_development_result_file))
  end

  test "should destroy job_development_result_file" do
    assert_difference('JobDevelopmentResultFile.count', -1) do
      delete :destroy, id: @job_development_result_file
    end

    assert_redirected_to jobs_job_development_result_files_path
  end
end
