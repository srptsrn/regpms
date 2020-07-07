require 'test_helper'

class EdpexKkuItemsControllerTest < ActionController::TestCase
  setup do
    @edpex_kku_item = edpex_kku_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:edpex_kku_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create edpex_kku_item" do
    assert_difference('EdpexKkuItem.count') do
      post :create, edpex_kku_item: { edpex_kku_id: @edpex_kku_item.edpex_kku_id, institute: @edpex_kku_item.institute, name: @edpex_kku_item.name, no: @edpex_kku_item.no, target: @edpex_kku_item.target, year1: @edpex_kku_item.year1, year2: @edpex_kku_item.year2, year3: @edpex_kku_item.year3, year4: @edpex_kku_item.year4, year5: @edpex_kku_item.year5, year: @edpex_kku_item.year }
    end

    assert_redirected_to edpex_kku_item_path(assigns(:edpex_kku_item))
  end

  test "should show edpex_kku_item" do
    get :show, id: @edpex_kku_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @edpex_kku_item
    assert_response :success
  end

  test "should update edpex_kku_item" do
    patch :update, id: @edpex_kku_item, edpex_kku_item: { edpex_kku_id: @edpex_kku_item.edpex_kku_id, institute: @edpex_kku_item.institute, name: @edpex_kku_item.name, no: @edpex_kku_item.no, target: @edpex_kku_item.target, year1: @edpex_kku_item.year1, year2: @edpex_kku_item.year2, year3: @edpex_kku_item.year3, year4: @edpex_kku_item.year4, year5: @edpex_kku_item.year5, year: @edpex_kku_item.year }
    assert_redirected_to edpex_kku_item_path(assigns(:edpex_kku_item))
  end

  test "should destroy edpex_kku_item" do
    assert_difference('EdpexKkuItem.count', -1) do
      delete :destroy, id: @edpex_kku_item
    end

    assert_redirected_to edpex_kku_items_path
  end
end
