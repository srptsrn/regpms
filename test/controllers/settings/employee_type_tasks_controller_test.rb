require 'test_helper'

class Settings::EmployeeTypeTasksControllerTest < ActionController::TestCase
  setup do
    @employee_type_task = employee_type_tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:employee_type_tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create employee_type_task" do
    assert_difference('EmployeeTypeTask.count') do
      post :create, employee_type_task: { employee_type_task_group_id: @employee_type_task.employee_type_task_group_id, sorting: @employee_type_task.sorting, task_id: @employee_type_task.task_id, weight: @employee_type_task.weight, workflow_state: @employee_type_task.workflow_state, workflow_state_updater_id: @employee_type_task.workflow_state_updater_id }
    end

    assert_redirected_to settings_employee_type_task_path(assigns(:employee_type_task))
  end

  test "should show employee_type_task" do
    get :show, id: @employee_type_task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @employee_type_task
    assert_response :success
  end

  test "should update employee_type_task" do
    patch :update, id: @employee_type_task, employee_type_task: { employee_type_task_group_id: @employee_type_task.employee_type_task_group_id, sorting: @employee_type_task.sorting, task_id: @employee_type_task.task_id, weight: @employee_type_task.weight, workflow_state: @employee_type_task.workflow_state, workflow_state_updater_id: @employee_type_task.workflow_state_updater_id }
    assert_redirected_to settings_employee_type_task_path(assigns(:employee_type_task))
  end

  test "should destroy employee_type_task" do
    assert_difference('EmployeeTypeTask.count', -1) do
      delete :destroy, id: @employee_type_task
    end

    assert_redirected_to settings_employee_type_tasks_path
  end
end
