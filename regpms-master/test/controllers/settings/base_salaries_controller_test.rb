require 'test_helper'

class Settings::BaseSalariesControllerTest < ActionController::TestCase
  setup do
    @base_salary = base_salaries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:base_salaries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create base_salary" do
    assert_difference('BaseSalary.count') do
      post :create, base_salary: { base_high: @base_salary.base_high, base_low: @base_salary.base_low, evaluation_id: @base_salary.evaluation_id, max_high: @base_salary.max_high, max_low: @base_salary.max_low, min_high: @base_salary.min_high, min_low: @base_salary.min_low, position_level_id: @base_salary.position_level_id, remark: @base_salary.remark, workflow_state: @base_salary.workflow_state, workflow_state_updater_id: @base_salary.workflow_state_updater_id }
    end

    assert_redirected_to settings_base_salary_path(assigns(:base_salary))
  end

  test "should show base_salary" do
    get :show, id: @base_salary
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @base_salary
    assert_response :success
  end

  test "should update base_salary" do
    patch :update, id: @base_salary, base_salary: { base_high: @base_salary.base_high, base_low: @base_salary.base_low, evaluation_id: @base_salary.evaluation_id, max_high: @base_salary.max_high, max_low: @base_salary.max_low, min_high: @base_salary.min_high, min_low: @base_salary.min_low, position_level_id: @base_salary.position_level_id, remark: @base_salary.remark, workflow_state: @base_salary.workflow_state, workflow_state_updater_id: @base_salary.workflow_state_updater_id }
    assert_redirected_to settings_base_salary_path(assigns(:base_salary))
  end

  test "should destroy base_salary" do
    assert_difference('BaseSalary.count', -1) do
      delete :destroy, id: @base_salary
    end

    assert_redirected_to settings_base_salaries_path
  end
end
