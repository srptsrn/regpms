require 'test_helper'

class Projects::ResponsiblesControllerTest < ActionController::TestCase
  setup do
    @responsible = responsibles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:responsibles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create responsible" do
    assert_difference('Responsible.count') do
      post :create, responsible: { firstname: @responsible.firstname, lastname: @responsible.lastname, position: @responsible.position, prefix: @responsible.prefix, project_id: @responsible.project_id, sorting: @responsible.sorting, user_id: @responsible.user_id, workflow_state: @responsible.workflow_state, workflow_state_updater_id: @responsible.workflow_state_updater_id }
    end

    assert_redirected_to projects_responsible_path(assigns(:responsible))
  end

  test "should show responsible" do
    get :show, id: @responsible
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @responsible
    assert_response :success
  end

  test "should update responsible" do
    patch :update, id: @responsible, responsible: { firstname: @responsible.firstname, lastname: @responsible.lastname, position: @responsible.position, prefix: @responsible.prefix, project_id: @responsible.project_id, sorting: @responsible.sorting, user_id: @responsible.user_id, workflow_state: @responsible.workflow_state, workflow_state_updater_id: @responsible.workflow_state_updater_id }
    assert_redirected_to projects_responsible_path(assigns(:responsible))
  end

  test "should destroy responsible" do
    assert_difference('Responsible.count', -1) do
      delete :destroy, id: @responsible
    end

    assert_redirected_to projects_responsibles_path
  end
end
