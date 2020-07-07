require 'test_helper'

class Settings::TacticsControllerTest < ActionController::TestCase
  setup do
    @tactic = tactics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tactics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tactic" do
    assert_difference('Tactic.count') do
      post :create, tactic: { name: @tactic.name, sorting: @tactic.sorting, strategy_id: @tactic.strategy_id, workflow_state: @tactic.workflow_state, workflow_state_updater_id: @tactic.workflow_state_updater_id }
    end

    assert_redirected_to settings_tactic_path(assigns(:tactic))
  end

  test "should show tactic" do
    get :show, id: @tactic
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tactic
    assert_response :success
  end

  test "should update tactic" do
    patch :update, id: @tactic, tactic: { name: @tactic.name, sorting: @tactic.sorting, strategy_id: @tactic.strategy_id, workflow_state: @tactic.workflow_state, workflow_state_updater_id: @tactic.workflow_state_updater_id }
    assert_redirected_to settings_tactic_path(assigns(:tactic))
  end

  test "should destroy tactic" do
    assert_difference('Tactic.count', -1) do
      delete :destroy, id: @tactic
    end

    assert_redirected_to settings_tactics_path
  end
end
