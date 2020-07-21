require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  setup do
    @message = messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create message" do
    assert_difference('Message.count') do
      post :create, message: { body: @message.body, message_id: @message.message_id, topic: @message.topic, user_id: @message.user_id, workflow_state: @message.workflow_state, workflow_state_updater_id: @message.workflow_state_updater_id }
    end

    assert_redirected_to message_path(assigns(:message))
  end

  test "should show message" do
    get :show, id: @message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @message
    assert_response :success
  end

  test "should update message" do
    patch :update, id: @message, message: { body: @message.body, message_id: @message.message_id, topic: @message.topic, user_id: @message.user_id, workflow_state: @message.workflow_state, workflow_state_updater_id: @message.workflow_state_updater_id }
    assert_redirected_to message_path(assigns(:message))
  end

  test "should destroy message" do
    assert_difference('Message.count', -1) do
      delete :destroy, id: @message
    end

    assert_redirected_to messages_path
  end
end
