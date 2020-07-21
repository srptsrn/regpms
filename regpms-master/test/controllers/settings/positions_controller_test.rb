require 'test_helper'

class Settings::PositionsControllerTest < ActionController::TestCase
  setup do
    @position = positions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:positions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create position" do
    assert_difference('Position.count') do
      post :create, position: { name: @position.name, position_type_id: @position.position_type_id, workflow_state: @position.workflow_state, workflow_state_updater_id: @position.workflow_state_updater_id }
    end

    assert_redirected_to settings_position_path(assigns(:position))
  end

  test "should show position" do
    get :show, id: @position
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @position
    assert_response :success
  end

  test "should update position" do
    patch :update, id: @position, position: { name: @position.name, position_type_id: @position.position_type_id, workflow_state: @position.workflow_state, workflow_state_updater_id: @position.workflow_state_updater_id }
    assert_redirected_to settings_position_path(assigns(:position))
  end

  test "should destroy position" do
    assert_difference('Position.count', -1) do
      delete :destroy, id: @position
    end

    assert_redirected_to settings_positions_path
  end
end
