require 'test_helper'

class Settings::EvaluationPrinciplesControllerTest < ActionController::TestCase
  setup do
    @evaluation_principle = evaluation_principles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:evaluation_principles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create evaluation_principle" do
    assert_difference('EvaluationPrinciple.count') do
      post :create, evaluation_principle: { evaluation_id: @evaluation_principle.evaluation_id, principle1: @evaluation_principle.principle1, principle2: @evaluation_principle.principle2, principle3: @evaluation_principle.principle3, principle4: @evaluation_principle.principle4, principle5: @evaluation_principle.principle5, task_id: @evaluation_principle.task_id, workflow_state: @evaluation_principle.workflow_state, workflow_state_updater_id: @evaluation_principle.workflow_state_updater_id }
    end

    assert_redirected_to settings_evaluation_principle_path(assigns(:evaluation_principle))
  end

  test "should show evaluation_principle" do
    get :show, id: @evaluation_principle
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @evaluation_principle
    assert_response :success
  end

  test "should update evaluation_principle" do
    patch :update, id: @evaluation_principle, evaluation_principle: { evaluation_id: @evaluation_principle.evaluation_id, principle1: @evaluation_principle.principle1, principle2: @evaluation_principle.principle2, principle3: @evaluation_principle.principle3, principle4: @evaluation_principle.principle4, principle5: @evaluation_principle.principle5, task_id: @evaluation_principle.task_id, workflow_state: @evaluation_principle.workflow_state, workflow_state_updater_id: @evaluation_principle.workflow_state_updater_id }
    assert_redirected_to settings_evaluation_principle_path(assigns(:evaluation_principle))
  end

  test "should destroy evaluation_principle" do
    assert_difference('EvaluationPrinciple.count', -1) do
      delete :destroy, id: @evaluation_principle
    end

    assert_redirected_to settings_evaluation_principles_path
  end
end
