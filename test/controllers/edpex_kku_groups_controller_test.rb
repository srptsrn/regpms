require 'test_helper'

class EdpexKkuGroupsControllerTest < ActionController::TestCase
  setup do
    @edpex_kku_group = edpex_kku_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:edpex_kku_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create edpex_kku_group" do
    assert_difference('EdpexKkuGroup.count') do
      post :create, edpex_kku_group: { name: @edpex_kku_group.name, no: @edpex_kku_group.no }
    end

    assert_redirected_to edpex_kku_group_path(assigns(:edpex_kku_group))
  end

  test "should show edpex_kku_group" do
    get :show, id: @edpex_kku_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @edpex_kku_group
    assert_response :success
  end

  test "should update edpex_kku_group" do
    patch :update, id: @edpex_kku_group, edpex_kku_group: { name: @edpex_kku_group.name, no: @edpex_kku_group.no }
    assert_redirected_to edpex_kku_group_path(assigns(:edpex_kku_group))
  end

  test "should destroy edpex_kku_group" do
    assert_difference('EdpexKkuGroup.count', -1) do
      delete :destroy, id: @edpex_kku_group
    end

    assert_redirected_to edpex_kku_groups_path
  end
end
