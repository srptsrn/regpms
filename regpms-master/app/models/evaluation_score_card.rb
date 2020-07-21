class EvaluationScoreCard < ActiveRecord::Base
  
  SELF_TASK_SCORES = (35..70).collect {|sc| sc}.reverse
  SELF_ABILITY_SCORES = (15..30).collect {|sc| sc}.reverse
  
  STAFF_TASK_SCORES = (20..40).collect {|sc| sc}.reverse
  STAFF_ABILITY_SCORES = (10..20).collect {|sc| sc}.reverse
  
  BOARD_TASK_SCORES = (15..30).collect {|sc| sc}.reverse
  BOARD_ABILITY_SCORES = (5..10).collect {|sc| sc}.reverse
  
  belongs_to :workflow_state_updater, class_name: "User"
  belongs_to :evaluation
  belongs_to :user
  belongs_to :committee, class_name: "User"
  
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
