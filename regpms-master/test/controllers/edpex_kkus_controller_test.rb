require 'test_helper'

class EdpexKkusControllerTest < ActionController::TestCase
  setup do
    @edpex_kku = edpex_kkus(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:edpex_kkus)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create edpex_kku" do
    assert_difference('EdpexKku.count') do
      post :create, edpex_kku: { description: @edpex_kku.description, edpex_kku_group_id: @edpex_kku.edpex_kku_group_id, name: @edpex_kku.name, no: @edpex_kku.no, year: @edpex_kku.year }
    end

    assert_redirected_to edpex_kku_path(assigns(:edpex_kku))
  end

  test "should show edpex_kku" do
    get :show, id: @edpex_kku
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @edpex_kku
    assert_response :success
  end

  test "should update edpex_kku" do
    patch :update, id: @edpex_kku, edpex_kku: { description: @edpex_kku.description, edpex_kku_group_id: @edpex_kku.edpex_kku_group_id, name: @edpex_kku.name, no: @edpex_kku.no, year: @edpex_kku.year }
    assert_redirected_to edpex_kku_path(assigns(:edpex_kku))
  end

  test "should destroy edpex_kku" do
    assert_difference('EdpexKku.count', -1) do
      delete :destroy, id: @edpex_kku
    end

    assert_redirected_to edpex_kkus_path
  end
end
