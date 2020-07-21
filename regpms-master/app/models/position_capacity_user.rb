class PositionCapacityUser < ActiveRecord::Base
  
  belongs_to :workflow_state_updater, class_name: "User"
  belongs_to :position_capacity
  belongs_to :user
  belongs_to :evaluation
  belongs_to :committee, class_name: "User"
  
  after_save do
    eu = EvaluationUser.where(["user_id = ? AND evaluation_id = ? AND committee_id = ? AND role = ?", self.user_id, self.evaluation_id, self.committee_id, self.role]).first
    eu = EvaluationUser.create(
      user_id: self.user_id,
      evaluation_id: self.evaluation_id,
      committee_id: self.committee_id,
      role: self.role, 
      workflow_state: :enabled
    ) if eu.nil?
    eu.position_capacity_total = PositionCapacityUser.where(["user_id = ? AND evaluation_id = ? AND committee_id = ? AND role = ?", self.user_id, self.evaluation_id, self.committee_id, self.role]).collect {|pcu| pcu.score_real.to_f}.sum
    eu.save
  end
  
  def position_id
    position_capacity && position_capacity.position_capacity_group ? position_capacity.position_capacity_group.position_id : nil
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
