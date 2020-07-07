require 'test_helper'

class NewsFrontsControllerTest < ActionController::TestCase
  setup do
    @news_front = news_fronts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:news_fronts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create news_front" do
    assert_difference('NewsFront.count') do
      post :create, news_front: { detail: @news_front.detail, image: @news_front.image, published_at: @news_front.published_at, title: @news_front.title, workflow_state: @news_front.workflow_state, workflow_state_updater_id: @news_front.workflow_state_updater_id }
    end

    assert_redirected_to news_front_path(assigns(:news_front))
  end

  test "should show news_front" do
    get :show, id: @news_front
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @news_front
    assert_response :success
  end

  test "should update news_front" do
    patch :update, id: @news_front, news_front: { detail: @news_front.detail, image: @news_front.image, published_at: @news_front.published_at, title: @news_front.title, workflow_state: @news_front.workflow_state, workflow_state_updater_id: @news_front.workflow_state_updater_id }
    assert_redirected_to news_front_path(assigns(:news_front))
  end

  test "should destroy news_front" do
    assert_difference('NewsFront.count', -1) do
      delete :destroy, id: @news_front
    end

    assert_redirected_to news_fronts_path
  end
end
