class EmployeeTypeUser < ActiveRecord::Base
  
  scope :all_enabled, -> { order(nil).where(workflow_state: :enabled) }

  belongs_to :workflow_state_updater, class_name: "User"
  belongs_to :employee_type
  belongs_to :user
  belongs_to :evaluation

  has_many :employee_type_task_groups, -> { order(:sorting) }
  accepts_nested_attributes_for :employee_type_task_groups, :reject_if => :all_blank, :allow_destroy => true

  validates :user_id, presence: true, uniqueness: {scope: [:evaluation_id]}
  validates :evaluation_id, presence: true
  # validates :employee_type_id, presence: true

  def to_s
    employee_type
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
