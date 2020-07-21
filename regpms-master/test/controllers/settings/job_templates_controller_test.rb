require 'test_helper'

class Settings::JobTemplatesControllerTest < ActionController::TestCase
  setup do
    @job_template = job_templates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:job_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job_template" do
    assert_difference('JobTemplate.count') do
      post :create, job_template: { duration: @job_template.duration, is_job_development: @job_template.is_job_development, is_job_routine: @job_template.is_job_routine, is_job_vice: @job_template.is_job_vice, job_template_group_id: @job_template.job_template_group_id, name: @job_template.name, unit: @job_template.unit, workflow_state: @job_template.workflow_state, workflow_state_updater_id: @job_template.workflow_state_updater_id }
    end

    assert_redirected_to settings_job_template_path(assigns(:job_template))
  end

  test "should show job_template" do
    get :show, id: @job_template
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job_template
    assert_response :success
  end

  test "should update job_template" do
    patch :update, id: @job_template, job_template: { duration: @job_template.duration, is_job_development: @job_template.is_job_development, is_job_routine: @job_template.is_job_routine, is_job_vice: @job_template.is_job_vice, job_template_group_id: @job_template.job_template_group_id, name: @job_template.name, unit: @job_template.unit, workflow_state: @job_template.workflow_state, workflow_state_updater_id: @job_template.workflow_state_updater_id }
    assert_redirected_to settings_job_template_path(assigns(:job_template))
  end

  test "should destroy job_template" do
    assert_difference('JobTemplate.count', -1) do
      delete :destroy, id: @job_template
    end

    assert_redirected_to settings_job_templates_path
  end
end
