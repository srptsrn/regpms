require 'test_helper'

class Settings::BudgetTypesControllerTest < ActionController::TestCase
  setup do
    @budget_type = budget_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:budget_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create budget_type" do
    assert_difference('BudgetType.count') do
      post :create, budget_type: { name: @budget_type.name, workflow_state: @budget_type.workflow_state, workflow_state_updater_id: @budget_type.workflow_state_updater_id }
    end

    assert_redirected_to settings_budget_type_path(assigns(:budget_type))
  end

  test "should show budget_type" do
    get :show, id: @budget_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @budget_type
    assert_response :success
  end

  test "should update budget_type" do
    patch :update, id: @budget_type, budget_type: { name: @budget_type.name, workflow_state: @budget_type.workflow_state, workflow_state_updater_id: @budget_type.workflow_state_updater_id }
    assert_redirected_to settings_budget_type_path(assigns(:budget_type))
  end

  test "should destroy budget_type" do
    assert_difference('BudgetType.count', -1) do
      delete :destroy, id: @budget_type
    end

    assert_redirected_to settings_budget_types_path
  end
end
