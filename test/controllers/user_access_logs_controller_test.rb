require 'test_helper'

class UserAccessLogsControllerTest < ActionController::TestCase
  setup do
    @user_access_log = user_access_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_access_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_access_log" do
    assert_difference('UserAccessLog.count') do
      post :create, user_access_log: { action_name: @user_access_log.action_name, controller_name: @user_access_log.controller_name, ip: @user_access_log.ip, log_time: @user_access_log.log_time, params: @user_access_log.params, params_id: @user_access_log.params_id, user_id: @user_access_log.user_id, username: @user_access_log.username }
    end

    assert_redirected_to user_access_log_path(assigns(:user_access_log))
  end

  test "should show user_access_log" do
    get :show, id: @user_access_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_access_log
    assert_response :success
  end

  test "should update user_access_log" do
    patch :update, id: @user_access_log, user_access_log: { action_name: @user_access_log.action_name, controller_name: @user_access_log.controller_name, ip: @user_access_log.ip, log_time: @user_access_log.log_time, params: @user_access_log.params, params_id: @user_access_log.params_id, user_id: @user_access_log.user_id, username: @user_access_log.username }
    assert_redirected_to user_access_log_path(assigns(:user_access_log))
  end

  test "should destroy user_access_log" do
    assert_difference('UserAccessLog.count', -1) do
      delete :destroy, id: @user_access_log
    end

    assert_redirected_to user_access_logs_path
  end
end
