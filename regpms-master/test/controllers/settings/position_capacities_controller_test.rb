require 'test_helper'

class Settings::PositionCapacitiesControllerTest < ActionController::TestCase
  setup do
    @position_capacity = position_capacities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:position_capacities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create position_capacity" do
    assert_difference('PositionCapacity.count') do
      post :create, position_capacity: { capacity_id: @position_capacity.capacity_id, expect: @position_capacity.expect, position_capacity_group_id: @position_capacity.position_capacity_group_id, sorting: @position_capacity.sorting, weight: @position_capacity.weight, workflow_state: @position_capacity.workflow_state, workflow_state_updater_id: @position_capacity.workflow_state_updater_id }
    end

    assert_redirected_to settings_position_capacity_path(assigns(:position_capacity))
  end

  test "should show position_capacity" do
    get :show, id: @position_capacity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @position_capacity
    assert_response :success
  end

  test "should update position_capacity" do
    patch :update, id: @position_capacity, position_capacity: { capacity_id: @position_capacity.capacity_id, expect: @position_capacity.expect, position_capacity_group_id: @position_capacity.position_capacity_group_id, sorting: @position_capacity.sorting, weight: @position_capacity.weight, workflow_state: @position_capacity.workflow_state, workflow_state_updater_id: @position_capacity.workflow_state_updater_id }
    assert_redirected_to settings_position_capacity_path(assigns(:position_capacity))
  end

  test "should destroy position_capacity" do
    assert_difference('PositionCapacity.count', -1) do
      delete :destroy, id: @position_capacity
    end

    assert_redirected_to settings_position_capacities_path
  end
end
