require 'test_helper'

class E360ItemUsersControllerTest < ActionController::TestCase
  setup do
    @e360_item_user = e360_item_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:e360_item_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create e360_item_user" do
    assert_difference('E360ItemUser.count') do
      post :create, e360_item_user: { e360_item_id: @e360_item_user.e360_item_id, e360_user_id: @e360_item_user.e360_user_id, score: @e360_item_user.score }
    end

    assert_redirected_to e360_item_user_path(assigns(:e360_item_user))
  end

  test "should show e360_item_user" do
    get :show, id: @e360_item_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @e360_item_user
    assert_response :success
  end

  test "should update e360_item_user" do
    patch :update, id: @e360_item_user, e360_item_user: { e360_item_id: @e360_item_user.e360_item_id, e360_user_id: @e360_item_user.e360_user_id, score: @e360_item_user.score }
    assert_redirected_to e360_item_user_path(assigns(:e360_item_user))
  end

  test "should destroy e360_item_user" do
    assert_difference('E360ItemUser.count', -1) do
      delete :destroy, id: @e360_item_user
    end

    assert_redirected_to e360_item_users_path
  end
end
