require 'test_helper'

class Settings::EmployeeTypesControllerTest < ActionController::TestCase
  setup do
    @employee_type = employee_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:employee_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create employee_type" do
    assert_difference('EmployeeType.count') do
      post :create, employee_type: { name: @employee_type.name, sorting: @employee_type.sorting, workflow_state: @employee_type.workflow_state, workflow_state_updater_id: @employee_type.workflow_state_updater_id }
    end

    assert_redirected_to settings_employee_type_path(assigns(:employee_type))
  end

  test "should show employee_type" do
    get :show, id: @employee_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @employee_type
    assert_response :success
  end

  test "should update employee_type" do
    patch :update, id: @employee_type, employee_type: { name: @employee_type.name, sorting: @employee_type.sorting, workflow_state: @employee_type.workflow_state, workflow_state_updater_id: @employee_type.workflow_state_updater_id }
    assert_redirected_to settings_employee_type_path(assigns(:employee_type))
  end

  test "should destroy employee_type" do
    assert_difference('EmployeeType.count', -1) do
      delete :destroy, id: @employee_type
    end

    assert_redirected_to settings_employee_types_path
  end
end
