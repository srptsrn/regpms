require 'test_helper'

class NewsCalendarsControllerTest < ActionController::TestCase
  setup do
    @news_calendar = news_calendars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:news_calendars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create news_calendar" do
    assert_difference('NewsCalendar.count') do
      post :create, news_calendar: { detail: @news_calendar.detail, end_at: @news_calendar.end_at, published_at: @news_calendar.published_at, start_at: @news_calendar.start_at, title: @news_calendar.title, workflow_state: @news_calendar.workflow_state, workflow_state_updater_id: @news_calendar.workflow_state_updater_id }
    end

    assert_redirected_to news_calendar_path(assigns(:news_calendar))
  end

  test "should show news_calendar" do
    get :show, id: @news_calendar
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @news_calendar
    assert_response :success
  end

  test "should update news_calendar" do
    patch :update, id: @news_calendar, news_calendar: { detail: @news_calendar.detail, end_at: @news_calendar.end_at, published_at: @news_calendar.published_at, start_at: @news_calendar.start_at, title: @news_calendar.title, workflow_state: @news_calendar.workflow_state, workflow_state_updater_id: @news_calendar.workflow_state_updater_id }
    assert_redirected_to news_calendar_path(assigns(:news_calendar))
  end

  test "should destroy news_calendar" do
    assert_difference('NewsCalendar.count', -1) do
      delete :destroy, id: @news_calendar
    end

    assert_redirected_to news_calendars_path
  end
end
