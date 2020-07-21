require 'test_helper'

class Settings::TasksControllerTest < ActionController::TestCase
  setup do
    @task = tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post :create, task: { file: @task.file, name: @task.name, sorting: @task.sorting, workflow_state: @task.workflow_state, workflow_state_updater_id: @task.workflow_state_updater_id }
    end

    assert_redirected_to settings_task_path(assigns(:task))
  end

  test "should show task" do
    get :show, id: @task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @task
    assert_response :success
  end

  test "should update task" do
    patch :update, id: @task, task: { file: @task.file, name: @task.name, sorting: @task.sorting, workflow_state: @task.workflow_state, workflow_state_updater_id: @task.workflow_state_updater_id }
    assert_redirected_to settings_task_path(assigns(:task))
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete :destroy, id: @task
    end

    assert_redirected_to settings_tasks_path
  end
end
