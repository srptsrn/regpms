require 'test_helper'

class Settings::TeamsControllerTest < ActionController::TestCase
  setup do
    @team = teams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:teams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create team" do
    assert_difference('Team.count') do
      post :create, team: { leader_id: @team.leader_id, name: @team.name, workflow_state: @team.workflow_state, workflow_state_updater_id: @team.workflow_state_updater_id }
    end

    assert_redirected_to settings_team_path(assigns(:team))
  end

  test "should show team" do
    get :show, id: @team
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @team
    assert_response :success
  end

  test "should update team" do
    patch :update, id: @team, team: { leader_id: @team.leader_id, name: @team.name, workflow_state: @team.workflow_state, workflow_state_updater_id: @team.workflow_state_updater_id }
    assert_redirected_to settings_team_path(assigns(:team))
  end

  test "should destroy team" do
    assert_difference('Team.count', -1) do
      delete :destroy, id: @team
    end

    assert_redirected_to settings_teams_path
  end
end
