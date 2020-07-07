require 'test_helper'

class Settings::KkuStrategicPillarsControllerTest < ActionController::TestCase
  setup do
    @kku_strategic_pillar = kku_strategic_pillars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:kku_strategic_pillars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create kku_strategic_pillar" do
    assert_difference('KkuStrategicPillar.count') do
      post :create, kku_strategic_pillar: { name: @kku_strategic_pillar.name, no: @kku_strategic_pillar.no, workflow_state: @kku_strategic_pillar.workflow_state, workflow_state_updater_id: @kku_strategic_pillar.workflow_state_updater_id }
    end

    assert_redirected_to settings_kku_strategic_pillar_path(assigns(:kku_strategic_pillar))
  end

  test "should show kku_strategic_pillar" do
    get :show, id: @kku_strategic_pillar
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @kku_strategic_pillar
    assert_response :success
  end

  test "should update kku_strategic_pillar" do
    patch :update, id: @kku_strategic_pillar, kku_strategic_pillar: { name: @kku_strategic_pillar.name, no: @kku_strategic_pillar.no, workflow_state: @kku_strategic_pillar.workflow_state, workflow_state_updater_id: @kku_strategic_pillar.workflow_state_updater_id }
    assert_redirected_to settings_kku_strategic_pillar_path(assigns(:kku_strategic_pillar))
  end

  test "should destroy kku_strategic_pillar" do
    assert_difference('KkuStrategicPillar.count', -1) do
      delete :destroy, id: @kku_strategic_pillar
    end

    assert_redirected_to settings_kku_strategic_pillars_path
  end
end
