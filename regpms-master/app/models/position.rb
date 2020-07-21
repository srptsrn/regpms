class Position < ActiveRecord::Base
  
  scope :all_enabled, -> { order(:name).where(workflow_state: :enabled) }
  
  belongs_to :workflow_state_updater, class_name: "User"
  belongs_to :position_type
  belongs_to :position_level
  has_many :users
  
  has_many :position_capacity_groups, -> { order(:sorting) }
  accepts_nested_attributes_for :position_capacity_groups, :reject_if => :all_blank, :allow_destroy => true
  
  validates :name, presence: true, uniqueness: {scope: [:position_type_id, :position_level_id]}
  # validates :position_type_id, presence: true
  
  def to_s
    xxx = "#{name}"
    xxx += " (#{position_level})" if !position_level.blank? && position_level.to_s != "-"
    xxx += " (#{position_type})" if !position_type.blank? && position_type.to_s != "-"
    return xxx
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
