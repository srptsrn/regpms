require 'test_helper'

class Settings::JobTemplateGroupsControllerTest < ActionController::TestCase
  setup do
    @job_template_group = job_template_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:job_template_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job_template_group" do
    assert_difference('JobTemplateGroup.count') do
      post :create, job_template_group: { name: @job_template_group.name, sorting: @job_template_group.sorting, workflow_state: @job_template_group.workflow_state, workflow_state_updater_id: @job_template_group.workflow_state_updater_id }
    end

    assert_redirected_to settings_job_template_group_path(assigns(:job_template_group))
  end

  test "should show job_template_group" do
    get :show, id: @job_template_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job_template_group
    assert_response :success
  end

  test "should update job_template_group" do
    patch :update, id: @job_template_group, job_template_group: { name: @job_template_group.name, sorting: @job_template_group.sorting, workflow_state: @job_template_group.workflow_state, workflow_state_updater_id: @job_template_group.workflow_state_updater_id }
    assert_redirected_to settings_job_template_group_path(assigns(:job_template_group))
  end

  test "should destroy job_template_group" do
    assert_difference('JobTemplateGroup.count', -1) do
      delete :destroy, id: @job_template_group
    end

    assert_redirected_to settings_job_template_groups_path
  end
end
