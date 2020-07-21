require 'test_helper'

class E360UsersControllerTest < ActionController::TestCase
  setup do
    @e360_user = e360_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:e360_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create e360_user" do
    assert_difference('E360User.count') do
      post :create, e360_user: { committee_id: @e360_user.committee_id, evaluation_id: @e360_user.evaluation_id, role: @e360_user.role, user_id: @e360_user.user_id, workflow_state: @e360_user.workflow_state, workflow_state_updater_id: @e360_user.workflow_state_updater_id }
    end

    assert_redirected_to e360_user_path(assigns(:e360_user))
  end

  test "should show e360_user" do
    get :show, id: @e360_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @e360_user
    assert_response :success
  end

  test "should update e360_user" do
    patch :update, id: @e360_user, e360_user: { committee_id: @e360_user.committee_id, evaluation_id: @e360_user.evaluation_id, role: @e360_user.role, user_id: @e360_user.user_id, workflow_state: @e360_user.workflow_state, workflow_state_updater_id: @e360_user.workflow_state_updater_id }
    assert_redirected_to e360_user_path(assigns(:e360_user))
  end

  test "should destroy e360_user" do
    assert_difference('E360User.count', -1) do
      delete :destroy, id: @e360_user
    end

    assert_redirected_to e360_users_path
  end
end
