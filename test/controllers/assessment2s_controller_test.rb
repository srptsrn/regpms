require 'test_helper'

class Assessment2sControllerTest < ActionController::TestCase
  setup do
    @assessment2 = assessment2s(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assessment2s)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assessment2" do
    assert_difference('Assessment2.count') do
      post :create, assessment2: { comment1: @assessment2.comment1, comment2: @assessment2.comment2, committee_id: @assessment2.committee_id, evaluation_id: @assessment2.evaluation_id, role: @assessment2.role, score111: @assessment2.score111, score112: @assessment2.score112, score113: @assessment2.score113, score114: @assessment2.score114, score121: @assessment2.score121, score122: @assessment2.score122, score123: @assessment2.score123, score124: @assessment2.score124, score211: @assessment2.score211, score212: @assessment2.score212, score213: @assessment2.score213, score214: @assessment2.score214, score215: @assessment2.score215, score221: @assessment2.score221, score222: @assessment2.score222, score223: @assessment2.score223, score224: @assessment2.score224, user_id: @assessment2.user_id, workflow_state: @assessment2.workflow_state, workflow_state_updater_id: @assessment2.workflow_state_updater_id }
    end

    assert_redirected_to assessment2_path(assigns(:assessment2))
  end

  test "should show assessment2" do
    get :show, id: @assessment2
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @assessment2
    assert_response :success
  end

  test "should update assessment2" do
    patch :update, id: @assessment2, assessment2: { comment1: @assessment2.comment1, comment2: @assessment2.comment2, committee_id: @assessment2.committee_id, evaluation_id: @assessment2.evaluation_id, role: @assessment2.role, score111: @assessment2.score111, score112: @assessment2.score112, score113: @assessment2.score113, score114: @assessment2.score114, score121: @assessment2.score121, score122: @assessment2.score122, score123: @assessment2.score123, score124: @assessment2.score124, score211: @assessment2.score211, score212: @assessment2.score212, score213: @assessment2.score213, score214: @assessment2.score214, score215: @assessment2.score215, score221: @assessment2.score221, score222: @assessment2.score222, score223: @assessment2.score223, score224: @assessment2.score224, user_id: @assessment2.user_id, workflow_state: @assessment2.workflow_state, workflow_state_updater_id: @assessment2.workflow_state_updater_id }
    assert_redirected_to assessment2_path(assigns(:assessment2))
  end

  test "should destroy assessment2" do
    assert_difference('Assessment2.count', -1) do
      delete :destroy, id: @assessment2
    end

    assert_redirected_to assessment2s_path
  end
end
