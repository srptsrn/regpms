require 'test_helper'

class Settings::EvaluationEmployeeTypesControllerTest < ActionController::TestCase
  setup do
    @evaluation_employee_type = evaluation_employee_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:evaluation_employee_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create evaluation_employee_type" do
    assert_difference('EvaluationEmployeeType.count') do
      post :create, evaluation_employee_type: { ability_ratio: @evaluation_employee_type.ability_ratio, committee_ratio: @evaluation_employee_type.committee_ratio, employee_type_id: @evaluation_employee_type.employee_type_id, evaluation_id: @evaluation_employee_type.evaluation_id, leader_ratio: @evaluation_employee_type.leader_ratio, task_ratio: @evaluation_employee_type.task_ratio, workflow_state: @evaluation_employee_type.workflow_state, workflow_state_updater_id: @evaluation_employee_type.workflow_state_updater_id }
    end

    assert_redirected_to settings_evaluation_employee_type_path(assigns(:evaluation_employee_type))
  end

  test "should show evaluation_employee_type" do
    get :show, id: @evaluation_employee_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @evaluation_employee_type
    assert_response :success
  end

  test "should update evaluation_employee_type" do
    patch :update, id: @evaluation_employee_type, evaluation_employee_type: { ability_ratio: @evaluation_employee_type.ability_ratio, committee_ratio: @evaluation_employee_type.committee_ratio, employee_type_id: @evaluation_employee_type.employee_type_id, evaluation_id: @evaluation_employee_type.evaluation_id, leader_ratio: @evaluation_employee_type.leader_ratio, task_ratio: @evaluation_employee_type.task_ratio, workflow_state: @evaluation_employee_type.workflow_state, workflow_state_updater_id: @evaluation_employee_type.workflow_state_updater_id }
    assert_redirected_to settings_evaluation_employee_type_path(assigns(:evaluation_employee_type))
  end

  test "should destroy evaluation_employee_type" do
    assert_difference('EvaluationEmployeeType.count', -1) do
      delete :destroy, id: @evaluation_employee_type
    end

    assert_redirected_to settings_evaluation_employee_types_path
  end
end
