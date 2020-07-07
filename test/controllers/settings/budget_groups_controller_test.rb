require 'test_helper'

class Settings::BudgetGroupsControllerTest < ActionController::TestCase
  setup do
    @budget_group = budget_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:budget_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create budget_group" do
    assert_difference('BudgetGroup.count') do
      post :create, budget_group: { name: @budget_group.name, workflow_state: @budget_group.workflow_state, workflow_state_updater_id: @budget_group.workflow_state_updater_id }
    end

    assert_redirected_to settings_budget_group_path(assigns(:budget_group))
  end

  test "should show budget_group" do
    get :show, id: @budget_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @budget_group
    assert_response :success
  end

  test "should update budget_group" do
    patch :update, id: @budget_group, budget_group: { name: @budget_group.name, workflow_state: @budget_group.workflow_state, workflow_state_updater_id: @budget_group.workflow_state_updater_id }
    assert_redirected_to settings_budget_group_path(assigns(:budget_group))
  end

  test "should destroy budget_group" do
    assert_difference('BudgetGroup.count', -1) do
      delete :destroy, id: @budget_group
    end

    assert_redirected_to settings_budget_groups_path
  end
end
