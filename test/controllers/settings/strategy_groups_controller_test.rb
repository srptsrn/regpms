require 'test_helper'

class Settings::StrategyGroupsControllerTest < ActionController::TestCase
  setup do
    @strategy_group = strategy_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:strategy_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create strategy_group" do
    assert_difference('StrategyGroup.count') do
      post :create, strategy_group: { name: @strategy_group.name, no: @strategy_group.no, workflow_state: @strategy_group.workflow_state, workflow_state_updater_id: @strategy_group.workflow_state_updater_id }
    end

    assert_redirected_to settings_strategy_group_path(assigns(:strategy_group))
  end

  test "should show strategy_group" do
    get :show, id: @strategy_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @strategy_group
    assert_response :success
  end

  test "should update strategy_group" do
    patch :update, id: @strategy_group, strategy_group: { name: @strategy_group.name, no: @strategy_group.no, workflow_state: @strategy_group.workflow_state, workflow_state_updater_id: @strategy_group.workflow_state_updater_id }
    assert_redirected_to settings_strategy_group_path(assigns(:strategy_group))
  end

  test "should destroy strategy_group" do
    assert_difference('StrategyGroup.count', -1) do
      delete :destroy, id: @strategy_group
    end

    assert_redirected_to settings_strategy_groups_path
  end
end
