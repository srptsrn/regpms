class Message < ActiveRecord::Base
  
  belongs_to :message
  belongs_to :user
  belongs_to :workflow_state_updater, class_name: "User"
  has_many :message_receivers
  
  def to_s
    topic
  end
  
  def sender
    user
  end
  
  def sender_avatar
    sender ? sender.avatar : nil
  end
  
  def sent_at
    created_at
  end
  
  def message_id
    id
  end
  
  def receivers
    message_receivers.collect {|mr| mr.user}
  end
  
  include Workflow
  workflow do
    state :new do
      event :draft, transitions_to: :drafted
      event :sendd, transitions_to: :sent
    end
    state :drafted, meta: {no_destroy: true} do
      event :sendd, transitions_to: :sent
      event :draft, transitions_to: :drafted
      event :terminate, transitions_to: :terminated
    end
    state :sent, meta: {no_destroy: true} do
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
    [:new, :drafted, :sent]
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
