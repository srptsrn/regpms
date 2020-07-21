class JobViceResult < ActiveRecord::Base
  
  scope :all_enabled, -> { order(:id).where(["workflow_state IN (?)", [:enabled, :confirmed]]) }
  
  belongs_to :workflow_state_updater, class_name: "User"
  belongs_to :user
  belongs_to :evaluation
  belongs_to :job_vice
  belongs_to :job_result_template
  belongs_to :approver, class_name: "User"
  
  has_many :job_vice_result_files, -> {order("created_at").where(["workflow_state IN (?)", [:enabled, :confirmed]])}
  accepts_nested_attributes_for :job_vice_result_files, :reject_if => :all_blank, :allow_destroy => true
  
  validates :user_id, presence: true
  validates :evaluation_id, presence: true
  validates :job_vice_id, presence: true
  # validates :job_result_template_id, presence: true
  validates :name, presence: true
  # validates :unit, presence: true
  # validates :duration, presence: true
  # validates :expect_qty, presence: true
  
  after_initialize do
    if self.new_record?
      self.name = self.job_result_template_name if self.name.blank?
    end
    self.unit = self.job_result_template_unit if self.respond_to?(:unit) && self.unit.blank?
    self.duration = self.job_result_template_duration if self.respond_to?(:duration) && self.duration.blank?
  end
  
  def to_s
    "#{evaluation} : #{user} : #{name}"
  end
  
  def is_pd_range
    evaluation.nil? || (evaluation.pd_start_date <= Date.current && evaluation.pd_end_date >= Date.current)
  end
  
  def is_pf_range
    evaluation.nil? || (evaluation.pf_start_date <= Date.current && evaluation.pf_end_date >= Date.current)
  end
  
  def job_result_template_name
    job_result_template ? job_result_template.name : ""
  end
  
  def job_result_template_unit
    job_result_template ? job_result_template.unit : ""
  end
  
  def job_result_template_duration
    job_result_template ? job_result_template.duration : ""
  end
  
  def job_template
    job_result_template ? job_result_template.job_template : nil
  end
  
  def job_template_name
    job_template ? job_template.name : ""
  end
  
  def job_template_group_name
    job_template ? job_template.job_template_group_name : ""
  end
  
  def job_result_files
    job_vice_result_files
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
      event :confirm, transitions_to: :confirmed
    end
    state :disabled, meta: {no_destroy: true} do
      event :enable, transitions_to: :enabled
      event :terminate, transitions_to: :terminated
    end
    state :confirmed, meta: {no_destroy: true} do
      event :unconfirm, transitions_to: :enabled
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
      update: [:save_change], 
      show: [:terminate], 
      index: [:terminate]
    }[action_name.to_sym]
  end
  
  def submit
    job_vice_result_files.each do |jrf| 
      jrf.workflow_state = :enabled
      jrf.save
    end
  end
  
  def save_change
    job_vice_result_files.each do |jrf| 
      jrf.workflow_state = :enabled
      jrf.save
    end
  end
  
  def enable
    job_vice_result_files.each do |jrf| 
      jrf.workflow_state = :enabled
      jrf.save
    end
  end
  
  def disable
    job_vice_result_files.each do |jrf| 
      jrf.workflow_state = :disabled
      jrf.save
    end
  end
  
  def terminate
    job_vice_result_files.each do |jrf| 
      jrf.workflow_state = :terminated
      jrf.save
    end
  end
  
end