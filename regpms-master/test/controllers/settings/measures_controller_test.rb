require 'test_helper'

class Settings::MeasuresControllerTest < ActionController::TestCase
  setup do
    @measure = measures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:measures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create measure" do
    assert_difference('Measure.count') do
      post :create, measure: { name: @measure.name, no: @measure.no, tactic_id: @measure.tactic_id, workflow_state: @measure.workflow_state, workflow_state_updater_id: @measure.workflow_state_updater_id }
    end

    assert_redirected_to settings_measure_path(assigns(:measure))
  end

  test "should show measure" do
    get :show, id: @measure
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @measure
    assert_response :success
  end

  test "should update measure" do
    patch :update, id: @measure, measure: { name: @measure.name, no: @measure.no, tactic_id: @measure.tactic_id, workflow_state: @measure.workflow_state, workflow_state_updater_id: @measure.workflow_state_updater_id }
    assert_redirected_to settings_measure_path(assigns(:measure))
  end

  test "should destroy measure" do
    assert_difference('Measure.count', -1) do
      delete :destroy, id: @measure
    end

    assert_redirected_to settings_measures_path
  end
end
