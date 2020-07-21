class MessageReceiver < ActiveRecord::Base
  
  belongs_to :message
  belongs_to :user
  belongs_to :workflow_state_updater
  
  def topic
    message ? message.topic : ""
  end
  
  def sender
    message ? message.user : nil
  end
  
  def sender_avatar
    sender ? sender.avatar : nil
  end
  
  def sent_at
    message ? message.created_at : nil
  end
  
  include Workflow
  workflow do
    state :new do
      event :submit, transitions_to: :unseen
      event :read, transitions_to: :seen
    end
    state :unseen, meta: {no_destroy: true} do
      event :read, transitions_to: :seen
    end
    state :seen, meta: {no_destroy: true} do
      event :archive, transitions_to: :archived
      event :trash, transitions_to: :trashed
    end
    state :archived, meta: {no_destroy: true} do
      event :trash, transitions_to: :trashed
    end
    state :trashed, meta: {no_destroy: true} do
      event :archive, transitions_to: :archived
      event :terminate, transitions_to: :terminated
    end
    state :terminated, meta: {no_destroy: true, disabled: true}

    on_transition do |from, to, event, *event_args|
      WorkflowStateLog.create({
        resource_class: self.class.to_s,
        resource_id: self.id,
        state_from: from,
        state_to: to,
        event: event,
        serialized_object: YAML.dump(self)
      })
    end
  end

  def self.active_states
    [:new, :seen, :unseen, :archived]
  end

  def self.form_action_events(action_name = nil)
    {
      new: [:submit],
      create: [:submit], 
      edit: [:save_change],
      update: [:save_change,], 
      show: [:enable, :disable, :terminate], 
      index: [:terminate]
    }[action_name.to_sym]
  end
  
end
