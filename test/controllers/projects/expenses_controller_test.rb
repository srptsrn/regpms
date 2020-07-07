require 'test_helper'

class Projects::ExpensesControllerTest < ActionController::TestCase
  setup do
    @expense = expenses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:expenses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create expense" do
    assert_difference('Expense.count') do
      post :create, expense: { amount: @expense.amount, budget_type_id: @expense.budget_type_id, by: @expense.by, date: @expense.date, description: @expense.description, project_id: @expense.project_id, sorting: @expense.sorting, workflow_state: @expense.workflow_state, workflow_state_updater_id: @expense.workflow_state_updater_id }
    end

    assert_redirected_to projects_expense_path(assigns(:expense))
  end

  test "should show expense" do
    get :show, id: @expense
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @expense
    assert_response :success
  end

  test "should update expense" do
    patch :update, id: @expense, expense: { amount: @expense.amount, budget_type_id: @expense.budget_type_id, by: @expense.by, date: @expense.date, description: @expense.description, project_id: @expense.project_id, sorting: @expense.sorting, workflow_state: @expense.workflow_state, workflow_state_updater_id: @expense.workflow_state_updater_id }
    assert_redirected_to projects_expense_path(assigns(:expense))
  end

  test "should destroy expense" do
    assert_difference('Expense.count', -1) do
      delete :destroy, id: @expense
    end

    assert_redirected_to projects_expenses_path
  end
end
