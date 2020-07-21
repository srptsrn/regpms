require 'test_helper'

class Settings::EvaluationsControllerTest < ActionController::TestCase
  setup do
    @evaluation = evaluations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:evaluations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create evaluation" do
    assert_difference('Evaluation.count') do
      post :create, evaluation: { confirm_end_date: @evaluation.confirm_end_date, confirm_start_date: @evaluation.confirm_start_date, director_id: @evaluation.director_id, episode: @evaluation.episode, evaluation_end_date: @evaluation.evaluation_end_date, evaluation_start_date: @evaluation.evaluation_start_date, pd_end_date: @evaluation.pd_end_date, pd_start_date: @evaluation.pd_start_date, pf_end_date: @evaluation.pf_end_date, pf_start_date: @evaluation.pf_start_date, secretary_id: @evaluation.secretary_id, vice_director_id: @evaluation.vice_director_id, workflow_state: @evaluation.workflow_state, workflow_state_updater_id: @evaluation.workflow_state_updater_id, year: @evaluation.year }
    end

    assert_redirected_to settings_evaluation_path(assigns(:evaluation))
  end

  test "should show evaluation" do
    get :show, id: @evaluation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @evaluation
    assert_response :success
  end

  test "should update evaluation" do
    patch :update, id: @evaluation, evaluation: { confirm_end_date: @evaluation.confirm_end_date, confirm_start_date: @evaluation.confirm_start_date, director_id: @evaluation.director_id, episode: @evaluation.episode, evaluation_end_date: @evaluation.evaluation_end_date, evaluation_start_date: @evaluation.evaluation_start_date, pd_end_date: @evaluation.pd_end_date, pd_start_date: @evaluation.pd_start_date, pf_end_date: @evaluation.pf_end_date, pf_start_date: @evaluation.pf_start_date, secretary_id: @evaluation.secretary_id, vice_director_id: @evaluation.vice_director_id, workflow_state: @evaluation.workflow_state, workflow_state_updater_id: @evaluation.workflow_state_updater_id, year: @evaluation.year }
    assert_redirected_to settings_evaluation_path(assigns(:evaluation))
  end

  test "should destroy evaluation" do
    assert_difference('Evaluation.count', -1) do
      delete :destroy, id: @evaluation
    end

    assert_redirected_to settings_evaluations_path
  end
end
