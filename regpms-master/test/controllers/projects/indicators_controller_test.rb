require 'test_helper'

class Projects::IndicatorsControllerTest < ActionController::TestCase
  setup do
    @indicator = indicators(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:indicators)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create indicator" do
    assert_difference('Indicator.count') do
      post :create, indicator: { description: @indicator.description, project_id: @indicator.project_id, result1: @indicator.result1, result2: @indicator.result2, result3: @indicator.result3, sorting: @indicator.sorting, target: @indicator.target, workflow_state: @indicator.workflow_state, workflow_state_updater_id: @indicator.workflow_state_updater_id }
    end

    assert_redirected_to projects_indicator_path(assigns(:indicator))
  end

  test "should show indicator" do
    get :show, id: @indicator
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @indicator
    assert_response :success
  end

  test "should update indicator" do
    patch :update, id: @indicator, indicator: { description: @indicator.description, project_id: @indicator.project_id, result1: @indicator.result1, result2: @indicator.result2, result3: @indicator.result3, sorting: @indicator.sorting, target: @indicator.target, workflow_state: @indicator.workflow_state, workflow_state_updater_id: @indicator.workflow_state_updater_id }
    assert_redirected_to projects_indicator_path(assigns(:indicator))
  end

  test "should destroy indicator" do
    assert_difference('Indicator.count', -1) do
      delete :destroy, id: @indicator
    end

    assert_redirected_to projects_indicators_path
  end
end
