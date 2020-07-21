require 'test_helper'

class Settings::JobResultTemplatesControllerTest < ActionController::TestCase
  setup do
    @job_result_template = job_result_templates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:job_result_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job_result_template" do
    assert_difference('JobResultTemplate.count') do
      post :create, job_result_template: { duration: @job_result_template.duration, job_template_id: @job_result_template.job_template_id, name: @job_result_template.name, unit: @job_result_template.unit, workflow_state: @job_result_template.workflow_state, workflow_state_updater_id: @job_result_template.workflow_state_updater_id }
    end

    assert_redirected_to settings_job_result_template_path(assigns(:job_result_template))
  end

  test "should show job_result_template" do
    get :show, id: @job_result_template
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job_result_template
    assert_response :success
  end

  test "should update job_result_template" do
    patch :update, id: @job_result_template, job_result_template: { duration: @job_result_template.duration, job_template_id: @job_result_template.job_template_id, name: @job_result_template.name, unit: @job_result_template.unit, workflow_state: @job_result_template.workflow_state, workflow_state_updater_id: @job_result_template.workflow_state_updater_id }
    assert_redirected_to settings_job_result_template_path(assigns(:job_result_template))
  end

  test "should destroy job_result_template" do
    assert_difference('JobResultTemplate.count', -1) do
      delete :destroy, id: @job_result_template
    end

    assert_redirected_to settings_job_result_templates_path
  end
end
