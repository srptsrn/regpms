require 'test_helper'

class AssessmentsControllerTest < ActionController::TestCase
  setup do
    @assessment = assessments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assessments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assessment" do
    assert_difference('Assessment.count') do
      post :create, assessment: { comment1: @assessment.comment1, comment2: @assessment.comment2, committee_id: @assessment.committee_id, evaluation_id: @assessment.evaluation_id, role: @assessment.role, score111: @assessment.score111, score112: @assessment.score112, score113: @assessment.score113, score114: @assessment.score114, score211: @assessment.score211, score212: @assessment.score212, score213: @assessment.score213, score214: @assessment.score214, score215: @assessment.score215, score221: @assessment.score221, score222: @assessment.score222, score223: @assessment.score223, score224: @assessment.score224, score225: @assessment.score225, score226: @assessment.score226, user_id: @assessment.user_id, workflow_state: @assessment.workflow_state, workflow_state_updater_id: @assessment.workflow_state_updater_id }
    end

    assert_redirected_to assessment_path(assigns(:assessment))
  end

  test "should show assessment" do
    get :show, id: @assessment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @assessment
    assert_response :success
  end

  test "should update assessment" do
    patch :update, id: @assessment, assessment: { comment1: @assessment.comment1, comment2: @assessment.comment2, committee_id: @assessment.committee_id, evaluation_id: @assessment.evaluation_id, role: @assessment.role, score111: @assessment.score111, score112: @assessment.score112, score113: @assessment.score113, score114: @assessment.score114, score211: @assessment.score211, score212: @assessment.score212, score213: @assessment.score213, score214: @assessment.score214, score215: @assessment.score215, score221: @assessment.score221, score222: @assessment.score222, score223: @assessment.score223, score224: @assessment.score224, score225: @assessment.score225, score226: @assessment.score226, user_id: @assessment.user_id, workflow_state: @assessment.workflow_state, workflow_state_updater_id: @assessment.workflow_state_updater_id }
    assert_redirected_to assessment_path(assigns(:assessment))
  end

  test "should destroy assessment" do
    assert_difference('Assessment.count', -1) do
      delete :destroy, id: @assessment
    end

    assert_redirected_to assessments_path
  end
end
