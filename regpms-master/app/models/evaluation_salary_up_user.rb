class EvaluationSalaryUpUser < ActiveRecord::Base

  belongs_to :workflow_state_updater, class_name: "User"
  belongs_to :evaluation
  belongs_to :evaluation_salary_up
  belongs_to :user
  belongs_to :position_level
  
  def evaluations
    evs = [evaluation]
    evs << evaluation.evaluation1 if evaluation.evaluation1
    evs << evaluation.evaluation2 if evaluation.evaluation2
    evs << evaluation.evaluation3 if evaluation.evaluation3
    evs << evaluation.evaluation4 if evaluation.evaluation4
    evs << evaluation.evaluation5 if evaluation.evaluation5
    return evs
  end
  
  def evaluation_ids
    evaluations.collect {|ev| ev.id}
  end
  
  def evaluation_salary_up_users
    EvaluationSalaryUpUser.where(["user_id = ? AND evaluation_id IN (?)", user_id, evaluation_ids])
  end
  
  def points
    evaluation_salary_up_users.collect {|esuu| esuu.point}
  end
  
  def avg_point_cal
    points.size > 0 ? points.sum.to_f / points.size : 0.0
  end
  
  def total_percent_of_up
    percent_of_up.to_f + percent_of_min_up.to_f
  end
  
  def max_change
    if point.to_f >= evaluation_salary_up.point_level5.to_f
      evaluation_salary_up.max_change5.to_f
    elsif point.to_f >= evaluation_salary_up.point_level4.to_f
      evaluation_salary_up.max_change4.to_f
    elsif point.to_f >= evaluation_salary_up.point_level3.to_f
      evaluation_salary_up.max_change3.to_f
    elsif point.to_f >= evaluation_salary_up.point_level2.to_f
      evaluation_salary_up.max_change2.to_f
    elsif point.to_f >= evaluation_salary_up.point_level1.to_f
      evaluation_salary_up.max_change1.to_f
    else
      0
    end
  end
  
  def is_out_of_range
    total_percent_of_up > max_change
  end
  
  def total_salary_up
    salary_up.to_f + salary_min_up.to_f
  end
  
  def new_salary
    salary.to_f + salary_up.to_f + salary_min_up.to_f
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
