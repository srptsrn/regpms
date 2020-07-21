# encoding: utf-8
require 'yaml'

class Ticket < ActiveRecord::Base

  PRIORTIES = [
    ["now", "danger"], 
    ["quick", "warning"], 
    ["normal", "primary"], 
    ["low", "info"]
  ]

  belongs_to :workflow_state_updater, class_name: "User"
  has_many :ticket_comments, -> {order("created_at")}
  has_many :ticket_attachments, -> {order("created_at")}
  has_and_belongs_to_many :users 
  
  accepts_nested_attributes_for :ticket_attachments, :reject_if => :all_blank, :allow_destroy => true
  
  validates :no, presence: true, uniqueness: true
  validates :name, presence: true
  validates :description, presence: true
  validates :priority, presence: true
  
  after_initialize do 
    if self.new_record?
      self.no ||= RunningNumber.generate_temp
    end
  end
  
  before_create do
    RunningNumber.generate
  end
  
  after_create do
    generate_notification
  end
  
  def to_s
    name
  end
  
  def priority_css
    pcss = PRIORTIES.select {|p| p[0] == priority.to_s}.first
    pcss ? pcss[1] : "default"
  end
  
  def last_ticket_comment
    ticket_comments.last
  end
  
  def last_ticket_comment_creator
    last_ticket_comment ? last_ticket_comment.creator : nil
  end
  
  def generate_notification
    (users + [creator]).collect {|u| u.id}.uniq.each do |uid|
      Notification.create(
        user_id: uid, 
        description: "#{creator} created Ticket##{no}",
        resource_class: "Ticket",
        resource_id: id, 
        url: "/tickets/#{id}"
      ).submit! unless creator_id == uid
    end
  end
  
  include OrbHelper
  def workflow_state_with_css
    twfst = I18n.t "workflow.state.#{workflow_state}"
    slc = state_label_class(workflow_state.to_sym)
    %{<span class="label #{slc}">#{twfst}</span>}.html_safe
  end
  
  include Workflow
  workflow do
    state :new do
      event :open, transitions_to: :opened
    end
    state :opened, meta: {no_destroy: true} do
      event :fix, transitions_to: :fixed
    end
    state :fixed, meta: {no_destroy: true} do
      event :reopen, transitions_to: :reopened
      event :close, transitions_to: :closed
    end
    state :closed, meta: {no_destroy: true} do
      event :reopen, transitions_to: :reopened
    end
    state :reopened, meta: {no_destroy: true} do
      event :fix, transitions_to: :fixed
    end

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
    [:new, :opened, :fixed, :reopened]
  end

  def self.form_action_events(action_name = nil)
    {
      new: [:open],
      create: [:open], 
      edit: [],
      update: [], 
      show: [:fixed, :reopened, :closed], 
      index: []
    }[action_name.to_sym]
  end
  
end
