class EvaluationUserFinal < ActiveRecord::Base
  
  belongs_to :workflow_state_updater, class_name: "User"
  belongs_to :evaluation
  belongs_to :director, class_name: "User"
  belongs_to :user
  
  after_initialize do
    escs = EvaluationScoreCard.where(["evaluation_id = ? AND user_id = ?", self.evaluation_id, self.user_id]).select {|esc| esc.task_score.to_i > 0 && esc.ability_score.to_i > 0}
    leader_escs = escs.select {|esc| esc.role == "director" || esc.role == "vice_director"}
    staff_escs = escs.select {|esc| esc.role == "staff"}
    
    self.leader_task_score = leader_escs.collect {|esc| esc.task_score.to_i}.sum
    self.leader_ability_score = leader_escs.collect {|esc| esc.ability_score.to_i}.sum
    self.staff_task_score = staff_escs.collect {|esc| esc.task_score.to_i}.sum
    self.staff_ability_score = staff_escs.collect {|esc| esc.ability_score.to_i}.sum
    self.save
  end
  
  def task_score
    leader_task_score.to_i + staff_task_score.to_i
  end
  
  def ability_score
    leader_ability_score.to_i + staff_ability_score.to_i
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
