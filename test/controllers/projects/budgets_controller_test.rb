require 'test_helper'

class Projects::BudgetsControllerTest < ActionController::TestCase
  setup do
    @budget = budgets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:budgets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create budget" do
    assert_difference('Budget.count') do
      post :create, budget: { amount: @budget.amount, budget_type_id: @budget.budget_type_id, description: @budget.description, project_id: @budget.project_id, sorting: @budget.sorting, workflow_state: @budget.workflow_state, workflow_state_updater_id: @budget.workflow_state_updater_id }
    end

    assert_redirected_to projects_budget_path(assigns(:budget))
  end

  test "should show budget" do
    get :show, id: @budget
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @budget
    assert_response :success
  end

  test "should update budget" do
    patch :update, id: @budget, budget: { amount: @budget.amount, budget_type_id: @budget.budget_type_id, description: @budget.description, project_id: @budget.project_id, sorting: @budget.sorting, workflow_state: @budget.workflow_state, workflow_state_updater_id: @budget.workflow_state_updater_id }
    assert_redirected_to projects_budget_path(assigns(:budget))
  end

  test "should destroy budget" do
    assert_difference('Budget.count', -1) do
      delete :destroy, id: @budget
    end

    assert_redirected_to projects_budgets_path
  end
end
