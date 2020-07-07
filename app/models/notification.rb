# encoding: utf-8
require 'yaml'

class Notification < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :workflow_state_updater, class_name: "User"
  
  def to_s
    description
  end
  
  def object
    resource_class && resource_class.constantize.exists?(resource_id) ? resource_class.constantize.find(resource_id) : nil
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
    state :seen, meta: {no_destroy: true, disabled: true}

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
    [:new, :unseen]
  end

  def self.form_action_events(action_name = nil)
    {
      new: [:submit],
      create: [:submit], 
      edit: [:read],
      update: [:read], 
      show: [:read], 
    }[action_name.to_sym]
  end
  
  def submit
    if resource_class.to_s == "Ticket"
      ticket = !resource_id.blank? && Ticket.exists?(resource_id) ? Ticket.find(resource_id) : nil
      NotificationMailer.delay.create_ticket(ticket) if ticket
    elsif resource_class.to_s == "TicketComment"
      ticket_comment = !resource_id.blank? && TicketComment.exists?(resource_id) ? TicketComment.find(resource_id) : nil
      NotificationMailer.delay.reply_ticket(ticket_comment) if ticket_comment
    end
  end
  
end
