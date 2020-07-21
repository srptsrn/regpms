#encoding: utf-8
class Evaluation < ActiveRecord::Base
  
  scope :all_actived, -> { order("year DESC, episode DESC").where(["workflow_state = ? OR workflow_state = ?", :enabled, :disabled]) }
  scope :all_enabled, -> { order("year DESC, episode DESC").where(["workflow_state = ?", :enabled]) }
  
  belongs_to :workflow_state_updater, class_name: "User"
  belongs_to :director, class_name: "User"
  belongs_to :vice_director, class_name: "User"
  belongs_to :vice_director2, class_name: "User"
  belongs_to :vice_director3, class_name: "User"
  belongs_to :secretary, class_name: "User"
  
  belongs_to :evaluation1, class_name: "Evaluation"
  belongs_to :evaluation2, class_name: "Evaluation"
  belongs_to :evaluation3, class_name: "Evaluation"
  belongs_to :evaluation4, class_name: "Evaluation"
  belongs_to :evaluation5, class_name: "Evaluation"
  
  has_many :committees, -> { order("users.firstname, users.lastname").includes(:user) }
  accepts_nested_attributes_for :committees, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :evaluation_principles, -> { order("tasks.sorting").includes(:task) }
  accepts_nested_attributes_for :evaluation_principles, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :evaluation_employee_types, -> { order("employee_types.sorting").includes(:employee_type) }
  accepts_nested_attributes_for :evaluation_employee_types, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :e360_items, -> { order("sorting") }
  accepts_nested_attributes_for :e360_items, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :base_salaries, -> { order("position_levels.sorting").includes(:position_level) }
  accepts_nested_attributes_for :base_salaries, :reject_if => :all_blank, :allow_destroy => true
  
  validates :year, presence: true
  validates :episode, presence: true, uniqueness: {scope: [:year]}
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :pd_start_date, presence: true
  validates :pd_end_date, presence: true
  validates :director_confirm_start_date, presence: true
  validates :director_confirm_end_date, presence: true
  validates :pf_start_date, presence: true
  validates :pf_end_date, presence: true
  validates :confirm_start_date, presence: true
  validates :confirm_end_date, presence: true
  validates :evaluation_start_date, presence: true
  validates :evaluation_end_date, presence: true
  validates :director, presence: true
  # validates :vice_director, presence: true
  validates :secretary, presence: true
  
  def to_s
    "#{year} / #{episode}"
  end
  
  def is_360?
    is_360
  end
  
  def self.current_evaluation
    Evaluation.all_enabled.first
  end
  
  def full
    "รอบที่ #{episode} (#{duration_thai})"
  end
  
  def full2
    "ครั้งที่ #{episode}/#{year} (รอบระหว่างวันที่ #{duration_thai})"
  end
  
  def duration_thai
    "#{evaluation_start_date.to_s_thai({year_prefix: "พ.ศ."})} ถึง #{evaluation_end_date.to_s_thai({year_prefix: "พ.ศ."})}"
  end
  
  def long_title
    "รอบการประเมิน ตั้งแต่วันที่ #{start_date.to_s_thai} ถึง #{end_date.to_s_thai} สำหรับ #{evaluation_employee_types.collect {|evet| evet.employee_type.to_s}.join(", ")}"
  end
  
  def long_title2
    "#{episode}/#{year} รอบระหว่างวันที่ #{duration_thai} สำหรับ #{evaluation_employee_types.collect {|evet| evet.employee_type.to_s}.join(", ")}"
  end
  
  def is_pd_range 
    pd_start_date <= Date.current && pd_end_date >= Date.current
  end
  
  def is_director_confirm_range 
    director_confirm_start_date <= Date.current && director_confirm_end_date >= Date.current
  end
  
  def is_pf_range 
    pf_start_date <= Date.current && pf_end_date >= Date.current
  end
  
  def is_confirm_range 
    confirm_start_date <= Date.current && confirm_end_date >= Date.current
  end
  
  def is_evaluation_range 
    evaluation_start_date <= Date.current && evaluation_end_date >= Date.current
  end
  
  def employee_type_ids
    evaluation_employee_types.collect {|evet| evet.employee_type.id}
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
      show: [:terminate], 
      index: [:terminate]
    }[action_name.to_sym]
  end
  
  def enable
    # Evaluation.where(["workflow_state = ?", :enabled]).each do |e|
      # e.disable!
    # end
  end
  
end
