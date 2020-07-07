require 'test_helper'

class NewsImagesControllerTest < ActionController::TestCase
  setup do
    @news_image = news_images(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:news_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create news_image" do
    assert_difference('NewsImage.count') do
      post :create, news_image: { image: @news_image.image, published_at: @news_image.published_at, workflow_state: @news_image.workflow_state, workflow_state_updater_id: @news_image.workflow_state_updater_id }
    end

    assert_redirected_to news_image_path(assigns(:news_image))
  end

  test "should show news_image" do
    get :show, id: @news_image
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @news_image
    assert_response :success
  end

  test "should update news_image" do
    patch :update, id: @news_image, news_image: { image: @news_image.image, published_at: @news_image.published_at, workflow_state: @news_image.workflow_state, workflow_state_updater_id: @news_image.workflow_state_updater_id }
    assert_redirected_to news_image_path(assigns(:news_image))
  end

  test "should destroy news_image" do
    assert_difference('NewsImage.count', -1) do
      delete :destroy, id: @news_image
    end

    assert_redirected_to news_images_path
  end
end
