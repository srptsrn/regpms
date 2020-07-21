require 'test_helper'

class PositionCapacityUsersControllerTest < ActionController::TestCase
  setup do
    @position_capacity_user = position_capacity_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:position_capacity_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create position_capacity_user" do
    assert_difference('PositionCapacityUser.count') do
      post :create, position_capacity_user: { committee_id: @position_capacity_user.committee_id, evaluation_id: @position_capacity_user.evaluation_id, expect: @position_capacity_user.expect, position_capacity_id: @position_capacity_user.position_capacity_id, role: @position_capacity_user.role, score: @position_capacity_user.score, score_real: @position_capacity_user.score_real, score_real_100: @position_capacity_user.score_real_100, score_real_expect: @position_capacity_user.score_real_expect, score_weight: @position_capacity_user.score_weight, user_id: @position_capacity_user.user_id, weight: @position_capacity_user.weight, workflow_state: @position_capacity_user.workflow_state, workflow_state_updater_id: @position_capacity_user.workflow_state_updater_id }
    end

    assert_redirected_to position_capacity_user_path(assigns(:position_capacity_user))
  end

  test "should show position_capacity_user" do
    get :show, id: @position_capacity_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @position_capacity_user
    assert_response :success
  end

  test "should update position_capacity_user" do
    patch :update, id: @position_capacity_user, position_capacity_user: { committee_id: @position_capacity_user.committee_id, evaluation_id: @position_capacity_user.evaluation_id, expect: @position_capacity_user.expect, position_capacity_id: @position_capacity_user.position_capacity_id, role: @position_capacity_user.role, score: @position_capacity_user.score, score_real: @position_capacity_user.score_real, score_real_100: @position_capacity_user.score_real_100, score_real_expect: @position_capacity_user.score_real_expect, score_weight: @position_capacity_user.score_weight, user_id: @position_capacity_user.user_id, weight: @position_capacity_user.weight, workflow_state: @position_capacity_user.workflow_state, workflow_state_updater_id: @position_capacity_user.workflow_state_updater_id }
    assert_redirected_to position_capacity_user_path(assigns(:position_capacity_user))
  end

  test "should destroy position_capacity_user" do
    assert_difference('PositionCapacityUser.count', -1) do
      delete :destroy, id: @position_capacity_user
    end

    assert_redirected_to position_capacity_users_path
  end
end
