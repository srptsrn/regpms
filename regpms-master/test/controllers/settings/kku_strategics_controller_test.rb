require 'test_helper'

class Settings::KkuStrategicsControllerTest < ActionController::TestCase
  setup do
    @kku_strategic = kku_strategics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:kku_strategics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create kku_strategic" do
    assert_difference('KkuStrategic.count') do
      post :create, kku_strategic: { kku_strategic_pillar_id: @kku_strategic.kku_strategic_pillar_id, name: @kku_strategic.name, no: @kku_strategic.no, workflow_state: @kku_strategic.workflow_state, workflow_state_updater_id: @kku_strategic.workflow_state_updater_id }
    end

    assert_redirected_to settings_kku_strategic_path(assigns(:kku_strategic))
  end

  test "should show kku_strategic" do
    get :show, id: @kku_strategic
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @kku_strategic
    assert_response :success
  end

  test "should update kku_strategic" do
    patch :update, id: @kku_strategic, kku_strategic: { kku_strategic_pillar_id: @kku_strategic.kku_strategic_pillar_id, name: @kku_strategic.name, no: @kku_strategic.no, workflow_state: @kku_strategic.workflow_state, workflow_state_updater_id: @kku_strategic.workflow_state_updater_id }
    assert_redirected_to settings_kku_strategic_path(assigns(:kku_strategic))
  end

  test "should destroy kku_strategic" do
    assert_difference('KkuStrategic.count', -1) do
      delete :destroy, id: @kku_strategic
    end

    assert_redirected_to settings_kku_strategics_path
  end
end
