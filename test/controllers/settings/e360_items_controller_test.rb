require 'test_helper'

class Settings::E360ItemsControllerTest < ActionController::TestCase
  setup do
    @e360_item = e360_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:e360_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create e360_item" do
    assert_difference('E360Item.count') do
      post :create, e360_item: { evaluation_id: @e360_item.evaluation_id, name: @e360_item.name, sorting: @e360_item.sorting, workflow_state: @e360_item.workflow_state, workflow_state_updater_id: @e360_item.workflow_state_updater_id }
    end

    assert_redirected_to settings_e360_item_path(assigns(:e360_item))
  end

  test "should show e360_item" do
    get :show, id: @e360_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @e360_item
    assert_response :success
  end

  test "should update e360_item" do
    patch :update, id: @e360_item, e360_item: { evaluation_id: @e360_item.evaluation_id, name: @e360_item.name, sorting: @e360_item.sorting, workflow_state: @e360_item.workflow_state, workflow_state_updater_id: @e360_item.workflow_state_updater_id }
    assert_redirected_to settings_e360_item_path(assigns(:e360_item))
  end

  test "should destroy e360_item" do
    assert_difference('E360Item.count', -1) do
      delete :destroy, id: @e360_item
    end

    assert_redirected_to settings_e360_items_path
  end
end
