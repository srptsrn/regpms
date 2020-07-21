class Responsible < ActiveRecord::Base
  
  belongs_to :workflow_state_updater, class_name: "User"
  belongs_to :project
  belongs_to :user
  
  validates :sorting, presence: true, uniqueness: {scope: [:project_id]}
  validates :user_id, presence: true, uniqueness: {scope: [:project_id]}
  validates :prefix, presence: true
  validates :firstname, presence: true
  validates :lastname, presence: true
  
  def to_s
    "#{sorting}. #{prefix}#{firstname} #{lastname}"
  end
  
  def to_s_short
    "#{sorting}. #{firstname}"
  end
  
  include Workflow
  workflow do
    state :new do
      event :submit, transitions_to: :enabled
    end
    state :enabled, meta: {no_destroy: true} do
      event :save_change, transitions_to: :enabled
      event :disable, transitions_to: :disabled
      event :terminate, transitions_to: :terminated
    end
    state :disabled, meta: {no_destroy: true} do
      event :save_change, transitions_to: :disabled
      event :enable, transitions_to: :enabled
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
    [:enabled, :disabled]
  end

  def self.form_action_events(action_name = nil)
    {
      new: [:submit],
      create: [:submit], 
      edit: [:save_change],
      update: [:save_change,], 
      show: [:enable, :disable, :terminate], 
      index: [:enable, :disable, :terminate]
    }[action_name.to_sym]
  end
  
end