require 'test_helper'

class Settings::PositionCapacityGroupsControllerTest < ActionController::TestCase
  setup do
    @position_capacity_group = position_capacity_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:position_capacity_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create position_capacity_group" do
    assert_difference('PositionCapacityGroup.count') do
      post :create, position_capacity_group: { name: @position_capacity_group.name, position_id: @position_capacity_group.position_id, sorting: @position_capacity_group.sorting, workflow_state: @position_capacity_group.workflow_state, workflow_state_updater_id: @position_capacity_group.workflow_state_updater_id }
    end

    assert_redirected_to settings_position_capacity_group_path(assigns(:position_capacity_group))
  end

  test "should show position_capacity_group" do
    get :show, id: @position_capacity_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @position_capacity_group
    assert_response :success
  end

  test "should update position_capacity_group" do
    patch :update, id: @position_capacity_group, position_capacity_group: { name: @position_capacity_group.name, position_id: @position_capacity_group.position_id, sorting: @position_capacity_group.sorting, workflow_state: @position_capacity_group.workflow_state, workflow_state_updater_id: @position_capacity_group.workflow_state_updater_id }
    assert_redirected_to settings_position_capacity_group_path(assigns(:position_capacity_group))
  end

  test "should destroy position_capacity_group" do
    assert_difference('PositionCapacityGroup.count', -1) do
      delete :destroy, id: @position_capacity_group
    end

    assert_redirected_to settings_position_capacity_groups_path
  end
end
