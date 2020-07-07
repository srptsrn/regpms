require 'test_helper'

class Projects::ProblemSuggesstionsControllerTest < ActionController::TestCase
  setup do
    @problem_suggesstion = problem_suggesstions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:problem_suggesstions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create problem_suggesstion" do
    assert_difference('ProblemSuggesstion.count') do
      post :create, problem_suggesstion: { description: @problem_suggesstion.description, project_id: @problem_suggesstion.project_id, sorting: @problem_suggesstion.sorting, workflow_state: @problem_suggesstion.workflow_state, workflow_state_updater_id: @problem_suggesstion.workflow_state_updater_id }
    end

    assert_redirected_to projects_problem_suggesstion_path(assigns(:problem_suggesstion))
  end

  test "should show problem_suggesstion" do
    get :show, id: @problem_suggesstion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @problem_suggesstion
    assert_response :success
  end

  test "should update problem_suggesstion" do
    patch :update, id: @problem_suggesstion, problem_suggesstion: { description: @problem_suggesstion.description, project_id: @problem_suggesstion.project_id, sorting: @problem_suggesstion.sorting, workflow_state: @problem_suggesstion.workflow_state, workflow_state_updater_id: @problem_suggesstion.workflow_state_updater_id }
    assert_redirected_to projects_problem_suggesstion_path(assigns(:problem_suggesstion))
  end

  test "should destroy problem_suggesstion" do
    assert_difference('ProblemSuggesstion.count', -1) do
      delete :destroy, id: @problem_suggesstion
    end

    assert_redirected_to projects_problem_suggesstions_path
  end
end
