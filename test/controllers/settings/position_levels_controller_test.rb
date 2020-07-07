require 'test_helper'

class Settings::PositionLevelsControllerTest < ActionController::TestCase
  setup do
    @position_level = position_levels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:position_levels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create position_level" do
    assert_difference('PositionLevel.count') do
      post :create, position_level: { name: @position_level.name, sorting: @position_level.sorting, workflow_state: @position_level.workflow_state, workflow_state_updater_id: @position_level.workflow_state_updater_id }
    end

    assert_redirected_to settings_position_level_path(assigns(:position_level))
  end

  test "should show position_level" do
    get :show, id: @position_level
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @position_level
    assert_response :success
  end

  test "should update position_level" do
    patch :update, id: @position_level, position_level: { name: @position_level.name, sorting: @position_level.sorting, workflow_state: @position_level.workflow_state, workflow_state_updater_id: @position_level.workflow_state_updater_id }
    assert_redirected_to settings_position_level_path(assigns(:position_level))
  end

  test "should destroy position_level" do
    assert_difference('PositionLevel.count', -1) do
      delete :destroy, id: @position_level
    end

    assert_redirected_to settings_position_levels_path
  end
end
