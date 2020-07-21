class EvaluationSalaryUp < ActiveRecord::Base

  belongs_to :workflow_state_updater, class_name: "User"
  belongs_to :evaluation
  has_many :evaluation_salary_up_users
  
  def total_quota_amount
    ((percent_of_change.to_f * total_amount.to_f) / 1000).to_i * 10 
  end
  
  def total_quota_amount2
    total_quota_amount - total_salary_min_up
  end
  
  def percent_of_quota_amount2
    total_eligible_amount.to_f > 0 ? ((100 * total_quota_amount2.to_f) / total_eligible_amount.to_f).to_s_decimal(1).to_f : 0.0
  end
  
  def percent_of_eligible
    total_eligible_amount.to_f > 0 ? ((100 * total_quota_amount.to_f) / total_eligible_amount.to_f).to_s_decimal.to_f : 0.0
  end
  
  def total_salary_min_up
    evaluation_salary_up_users.collect {|esuu| esuu.salary_min_up.to_f}.sum
  end
  
  def avg_point
    esuus = evaluation_salary_up_users.select {|esuu| esuu.is_eligible}
    return esuus.size > 0 ? esuus.collect {|esuu| esuu.point.to_f}.sum / esuus.size : 0
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
