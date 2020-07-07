class Activity < ActiveRecord::Base
  
  scope :all_enabled, -> { order(:created_at, :updated_at).where(workflow_state: Activity.enabled_states) }
  
  belongs_to :workflow_state_updater, class_name: "User"
  belongs_to :project

  has_many :activity_files, -> {order("created_at")}
  accepts_nested_attributes_for :activity_files, :reject_if => :all_blank, :allow_destroy => true
  
  validates :project_id, presence: true
  
  after_save do
    pj = self.project
    pj.is_started = true
    pj.save
  end
  
  def to_s
    name
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
    [:new, :enabled, :disabled]
  end

  def self.enabled_states
    [:enabled]
  end

  def self.form_action_events(action_name = nil)
    {
      new: [:submit],
      create: [:submit], 
      edit: [:save_change],
      update: [:save_change,], 
      show: [:terminate], 
      index: [:terminate]
    }[action_name.to_sym]
  end
  
end
