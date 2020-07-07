class PositionType < ActiveRecord::Base
  
  scope :all_enabled, -> { order(:sorting).where(workflow_state: :enabled) }
  
  belongs_to :workflow_state_updater, class_name: "User"
  
  validates :sorting, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  
  after_initialize do
    if self.new_record?
      self.sorting ||= (PositionType.last_sorting ? PositionType.last_sorting.sorting.to_i + 1 : 1)
    end
  end
  
  def to_s
    name
  end
  
  def self.last_sorting
    PositionType.limit(1).order("sorting DESC").first
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
