class PositionCapacity < ActiveRecord::Base
  
  scope :all_enabled, -> { order(:capacity_name).includes(:capacity).where(workflow_state: :enabled) }
  
  belongs_to :workflow_state_updater, class_name: "User"
  belongs_to :position_capacity_group
  belongs_to :capacity
  
  validates :capacity_id, presence: true
  validates :weight, presence: true
  validates :expect, presence: true
  
  def to_s
    capacity
  end
  
  def file
    capacity ? capacity.file : nil
  end
  
  include Workflow
  workflow do
    state :new do
      event :submit, transitions_to: :disabled
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
