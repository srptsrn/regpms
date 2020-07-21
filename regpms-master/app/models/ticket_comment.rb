class TicketComment < ActiveRecord::Base
  
  belongs_to :ticket
  belongs_to :workflow_state_updater, class_name: "User"
  
  after_create do
    generate_notification
  end
  
  def to_s
    description
  end
  
  def no
    ticket ? ticket.no : nil
  end
  
  def users
    ticket ? ticket.users : []
  end
  
  def generate_notification
    (users + [creator]).collect {|u| u.id}.uniq.each do |uid|
      Notification.create(
        user_id: uid, 
        description: "#{creator.to_s} commented on TICKET##{no}",
        resource_class: "TicketComment",
        resource_id: id, 
        url: "/tickets/#{ticket_id}"
      ).submit! unless creator_id == uid
    end
  end
  
  include Workflow
  workflow do
    state :new do
      event :reply, transitions_to: :replied
      event :reply_n_fix, transitions_to: :replied_n_fixed
      event :reply_n_open, transitions_to: :replied_n_opened
      event :reply_n_close, transitions_to: :replied_n_closed
    end
    state :replied, meta: {no_destroy: true}
    state :replied_n_fixed, meta: {no_destroy: true}
    state :replied_n_opened, meta: {no_destroy: true}
    state :replied_n_closed, meta: {no_destroy: true}

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
    [:reply, :reply_n_fix, :reply_n_open, :reply_n_close]
  end

  def self.form_action_events(action_name = nil)
    {
      new: [:reply, :reply_n_fix, :reply_n_open, :reply_n_close],
      create: [:reply, :reply_n_fix, :reply_n_open, :reply_n_close], 
      edit: [:reply, :reply_n_fix, :reply_n_open, :reply_n_close],
      update: [:reply, :reply_n_fix, :reply_n_open, :reply_n_close], 
      show: [:reply, :reply_n_fix, :reply_n_open, :reply_n_close], 
      index: [:reply, :reply_n_fix, :reply_n_open, :reply_n_close]
    }[action_name.to_sym]
  end
  
  def reply_n_fix
    ticket.fix!
    generate_notification
  end
  
  def reply_n_open
    ticket.reopen!
    generate_notification
  end
  
  def reply_n_close
    ticket.close!
    generate_notification
  end
  
end
