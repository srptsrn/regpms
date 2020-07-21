require 'test_helper'

class Settings::PositionTypesControllerTest < ActionController::TestCase
  setup do
    @position_type = position_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:position_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create position_type" do
    assert_difference('PositionType.count') do
      post :create, position_type: { name: @position_type.name, sorting: @position_type.sorting, workflow_state: @position_type.workflow_state, workflow_state_updater_id: @position_type.workflow_state_updater_id }
    end

    assert_redirected_to settings_position_type_path(assigns(:position_type))
  end

  test "should show position_type" do
    get :show, id: @position_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @position_type
    assert_response :success
  end

  test "should update position_type" do
    patch :update, id: @position_type, position_type: { name: @position_type.name, sorting: @position_type.sorting, workflow_state: @position_type.workflow_state, workflow_state_updater_id: @position_type.workflow_state_updater_id }
    assert_redirected_to settings_position_type_path(assigns(:position_type))
  end

  test "should destroy position_type" do
    assert_difference('PositionType.count', -1) do
      delete :destroy, id: @position_type
    end

    assert_redirected_to settings_position_types_path
  end
end
