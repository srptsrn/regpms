require 'test_helper'

class Projects::BenefitsControllerTest < ActionController::TestCase
  setup do
    @benefit = benefits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:benefits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create benefit" do
    assert_difference('Benefit.count') do
      post :create, benefit: { description: @benefit.description, project_id: @benefit.project_id, sorting: @benefit.sorting, workflow_state: @benefit.workflow_state, workflow_state_updater_id: @benefit.workflow_state_updater_id }
    end

    assert_redirected_to projects_benefit_path(assigns(:benefit))
  end

  test "should show benefit" do
    get :show, id: @benefit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @benefit
    assert_response :success
  end

  test "should update benefit" do
    patch :update, id: @benefit, benefit: { description: @benefit.description, project_id: @benefit.project_id, sorting: @benefit.sorting, workflow_state: @benefit.workflow_state, workflow_state_updater_id: @benefit.workflow_state_updater_id }
    assert_redirected_to projects_benefit_path(assigns(:benefit))
  end

  test "should destroy benefit" do
    assert_difference('Benefit.count', -1) do
      delete :destroy, id: @benefit
    end

    assert_redirected_to projects_benefits_path
  end
end
