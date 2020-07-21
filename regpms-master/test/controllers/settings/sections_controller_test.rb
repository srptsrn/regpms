require 'test_helper'

class Settings::SectionsControllerTest < ActionController::TestCase
  setup do
    @section = sections(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sections)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create section" do
    assert_difference('Section.count') do
      post :create, section: { leader_id: @section.leader_id, name: @section.name, vice_leader_id: @section.vice_leader_id, workflow_state: @section.workflow_state, workflow_state_updater_id: @section.workflow_state_updater_id }
    end

    assert_redirected_to settings_section_path(assigns(:section))
  end

  test "should show section" do
    get :show, id: @section
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @section
    assert_response :success
  end

  test "should update section" do
    patch :update, id: @section, section: { leader_id: @section.leader_id, name: @section.name, vice_leader_id: @section.vice_leader_id, workflow_state: @section.workflow_state, workflow_state_updater_id: @section.workflow_state_updater_id }
    assert_redirected_to settings_section_path(assigns(:section))
  end

  test "should destroy section" do
    assert_difference('Section.count', -1) do
      delete :destroy, id: @section
    end

    assert_redirected_to settings_sections_path
  end
end
