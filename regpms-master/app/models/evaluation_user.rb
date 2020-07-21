class EvaluationUser < ActiveRecord::Base
  
  belongs_to :workflow_state_updater, class_name: "User"
  belongs_to :user
  belongs_to :evaluation
  belongs_to :committee, class_name: "User"
  
  def evaluation_employee_type
    evaluation ? evaluation.evaluation_employee_types.where(["employee_type_id = ?", user.employee_type_id]).first : nil
  end
  
  def final_score
    return evaluation_employee_type ? (position_capacity_total.to_f * (evaluation_employee_type.ability_ratio.to_f / 100)) + (employee_type_task_total.to_f * (evaluation_employee_type.task_ratio.to_f / 100)) : 0
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
