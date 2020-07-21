require 'test_helper'

class EvaluationScoreCardsControllerTest < ActionController::TestCase
  setup do
    @evaluation_score_card = evaluation_score_cards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:evaluation_score_cards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create evaluation_score_card" do
    assert_difference('EvaluationScoreCard.count') do
      post :create, evaluation_score_card: { ability_score: @evaluation_score_card.ability_score, committee_id: @evaluation_score_card.committee_id, evaluation_id: @evaluation_score_card.evaluation_id, role: @evaluation_score_card.role, task_score: @evaluation_score_card.task_score, user_id: @evaluation_score_card.user_id, workflow_state: @evaluation_score_card.workflow_state, workflow_state_updater_id: @evaluation_score_card.workflow_state_updater_id }
    end

    assert_redirected_to evaluation_score_card_path(assigns(:evaluation_score_card))
  end

  test "should show evaluation_score_card" do
    get :show, id: @evaluation_score_card
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @evaluation_score_card
    assert_response :success
  end

  test "should update evaluation_score_card" do
    patch :update, id: @evaluation_score_card, evaluation_score_card: { ability_score: @evaluation_score_card.ability_score, committee_id: @evaluation_score_card.committee_id, evaluation_id: @evaluation_score_card.evaluation_id, role: @evaluation_score_card.role, task_score: @evaluation_score_card.task_score, user_id: @evaluation_score_card.user_id, workflow_state: @evaluation_score_card.workflow_state, workflow_state_updater_id: @evaluation_score_card.workflow_state_updater_id }
    assert_redirected_to evaluation_score_card_path(assigns(:evaluation_score_card))
  end

  test "should destroy evaluation_score_card" do
    assert_difference('EvaluationScoreCard.count', -1) do
      delete :destroy, id: @evaluation_score_card
    end

    assert_redirected_to evaluation_score_cards_path
  end
end
