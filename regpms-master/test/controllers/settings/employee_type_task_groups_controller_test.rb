require 'test_helper'

class Settings::EmployeeTypeTaskGroupsControllerTest < ActionController::TestCase
  setup do
    @employee_type_task_group = employee_type_task_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:employee_type_task_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create employee_type_task_group" do
    assert_difference('EmployeeTypeTaskGroup.count') do
      post :create, employee_type_task_group: { employee_type_id: @employee_type_task_group.employee_type_id, name: @employee_type_task_group.name, sorting: @employee_type_task_group.sorting, workflow_state: @employee_type_task_group.workflow_state, workflow_state_updater_id: @employee_type_task_group.workflow_state_updater_id }
    end

    assert_redirected_to settings_employee_type_task_group_path(assigns(:employee_type_task_group))
  end

  test "should show employee_type_task_group" do
    get :show, id: @employee_type_task_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @employee_type_task_group
    assert_response :success
  end

  test "should update employee_type_task_group" do
    patch :update, id: @employee_type_task_group, employee_type_task_group: { employee_type_id: @employee_type_task_group.employee_type_id, name: @employee_type_task_group.name, sorting: @employee_type_task_group.sorting, workflow_state: @employee_type_task_group.workflow_state, workflow_state_updater_id: @employee_type_task_group.workflow_state_updater_id }
    assert_redirected_to settings_employee_type_task_group_path(assigns(:employee_type_task_group))
  end

  test "should destroy employee_type_task_group" do
    assert_difference('EmployeeTypeTaskGroup.count', -1) do
      delete :destroy, id: @employee_type_task_group
    end

    assert_redirected_to settings_employee_type_task_groups_path
  end
end
