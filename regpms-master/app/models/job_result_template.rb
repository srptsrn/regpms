class JobResultTemplate < ActiveRecord::Base

  belongs_to :workflow_state_updater, class_name: "User"
  belongs_to :job_template
  
  validates :name, presence: true, uniqueness: {scope: [:job_template_id]}
  # validates :unit, presence: true
  # validates :duration, presence: true
  validates :job_template_id, presence: true
  
  def to_s
    name
  end
  
  def job_template_name
    job_template ? job_template.name : ""
  end
  
  def job_template_group
    job_template ? job_template.job_template_group : nil
  end
  
  def job_template_group_name
    job_template_group ? job_template_group.name : ""
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
    [:enabled]
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
