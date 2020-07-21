require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @project = projects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post :create, project: { budget_amount: @project.budget_amount, code: @project.code, from_date: @project.from_date, name: @project.name, objective: @project.objective, policy_id: @project.policy_id, rationale: @project.rationale, to_date: @project.to_date, workflow_state: @project.workflow_state, workflow_state_updater_id: @project.workflow_state_updater_id }
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test "should show project" do
    get :show, id: @project
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project
    assert_response :success
  end

  test "should update project" do
    patch :update, id: @project, project: { budget_amount: @project.budget_amount, code: @project.code, from_date: @project.from_date, name: @project.name, objective: @project.objective, policy_id: @project.policy_id, rationale: @project.rationale, to_date: @project.to_date, workflow_state: @project.workflow_state, workflow_state_updater_id: @project.workflow_state_updater_id }
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end
end
