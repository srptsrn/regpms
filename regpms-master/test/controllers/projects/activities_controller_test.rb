require 'test_helper'

class Projects::ActivitiesControllerTest < ActionController::TestCase
  setup do
    @activity = activities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:activities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create activity" do
    assert_difference('Activity.count') do
      post :create, activity: { description: @activity.description, from_date: @activity.from_date, location: @activity.location, name: @activity.name, number_of_participant: @activity.number_of_participant, project_id: @activity.project_id, sorting: @activity.sorting, to_date: @activity.to_date, workflow_state: @activity.workflow_state, workflow_state_updater_id: @activity.workflow_state_updater_id }
    end

    assert_redirected_to projects_activity_path(assigns(:activity))
  end

  test "should show activity" do
    get :show, id: @activity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @activity
    assert_response :success
  end

  test "should update activity" do
    patch :update, id: @activity, activity: { description: @activity.description, from_date: @activity.from_date, location: @activity.location, name: @activity.name, number_of_participant: @activity.number_of_participant, project_id: @activity.project_id, sorting: @activity.sorting, to_date: @activity.to_date, workflow_state: @activity.workflow_state, workflow_state_updater_id: @activity.workflow_state_updater_id }
    assert_redirected_to projects_activity_path(assigns(:activity))
  end

  test "should destroy activity" do
    assert_difference('Activity.count', -1) do
      delete :destroy, id: @activity
    end

    assert_redirected_to projects_activities_path
  end
end
