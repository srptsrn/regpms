require 'test_helper'

class Settings::PoliciesControllerTest < ActionController::TestCase
  setup do
    @policy = policies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:policies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create policy" do
    assert_difference('Policy.count') do
      post :create, policy: { code: @policy.code, name: @policy.name, policy_id: @policy.policy_id, workflow_state: @policy.workflow_state, workflow_state_updater_id: @policy.workflow_state_updater_id }
    end

    assert_redirected_to settings_policy_path(assigns(:policy))
  end

  test "should show policy" do
    get :show, id: @policy
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @policy
    assert_response :success
  end

  test "should update policy" do
    patch :update, id: @policy, policy: { code: @policy.code, name: @policy.name, policy_id: @policy.policy_id, workflow_state: @policy.workflow_state, workflow_state_updater_id: @policy.workflow_state_updater_id }
    assert_redirected_to settings_policy_path(assigns(:policy))
  end

  test "should destroy policy" do
    assert_difference('Policy.count', -1) do
      delete :destroy, id: @policy
    end

    assert_redirected_to settings_policies_path
  end
end
