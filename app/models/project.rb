# encoding: utf-8
class Project < ActiveRecord::Base
  
  DISABLED_STATES = [
    :disabled, 
    :terminated, 
    :project_approved, 
    :project_expensed
  ]
  
  scope :all_enabled, -> { order(:code).where(workflow_state: Project.active_states) }

  belongs_to :workflow_state_updater, class_name: "User"
  belongs_to :kku_strategic_pillar
  belongs_to :kku_strategic
  belongs_to :policy
  belongs_to :project
  belongs_to :budget_group
  belongs_to :strategy
  belongs_to :tactic
  
  belongs_to :strategy_group
  belongs_to :measure
  
  has_many :expenses, -> {order("date").where(["workflow_state IN (?)", [:enabled]])}
  
  has_many :responsibles, -> {order("sorting")}
  accepts_nested_attributes_for :responsibles, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :budgets, -> {order("sorting")}
  accepts_nested_attributes_for :budgets, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :objectives, -> {order("sorting")}
  accepts_nested_attributes_for :objectives, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :benefits, -> {order("sorting")}
  accepts_nested_attributes_for :benefits, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :indicators, -> {order("sorting")}
  accepts_nested_attributes_for :indicators, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :activities, -> {order("sorting").where(["workflow_state IN (?)", Activity.enabled_states])}
  accepts_nested_attributes_for :activities, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :problem_suggesstions, -> {order("sorting")}
  accepts_nested_attributes_for :problem_suggesstions, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :project_images, -> {order("created_at")}
  accepts_nested_attributes_for :project_images, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :projects, -> {order(:code).where(workflow_state: Project.active_states)}
  
  validates :code, presence: true, uniqueness: {if: Proc.new {|p| Project.where(["workflow_state IN (?)", [:draft, :enabled, :disabled, :finished]]).size > 0}}
  validates :name, presence: true
  # validates :objective, presence: {if: Proc.new {|p| current_state.to_sym != :new && current_state.to_sym != :drafted}}
  
  def children_expenses
    exs = []
    projects.each do |pj|
      exs += pj.expenses
      exs += pj.children_expenses
    end 
    return exs
  end
  
  def to_s
    "#{code} : #{name}"
  end
  
  def level
    code.to_s.split('-').size.to_i - 1
  end
  
  # def year
    # code.blank? ? nil : 2500 + code[0, 2].to_i
  # end
  
  def total_expense(ddd=nil)
    if ddd.class == Date
      expenses.where(["date <= ?", ddd]).collect {|ex| ex.amount.to_f}.sum # + children_total_expense(ddd)
    else
      expenses.collect {|ex| ex.amount.to_f}.sum # + children_total_expense
    end
  end
  
  def children_total_expense(ddd=nil)
    tx = 0
    if ddd.class == Date
      projects.each do |pj|
        tx += (pj.expenses.where(["date <= ?", ddd]).collect {|ex| ex.amount.to_f}.sum + pj.children_total_expense(ddd))
      end
    else
      projects.each do |pj|
        tx += (pj.expenses.collect {|ex| ex.amount.to_f}.sum + pj.children_total_expense)
      end
    end
    return tx
  end
  
  def balance(ddd=nil)
    budget_amount.to_f - total_expense(ddd)
  end 
  
  def budget_plan_total
    budget_plan_q1.to_f + budget_plan_q2.to_f + budget_plan_q3.to_f + budget_plan_q4.to_f
  end
  
  def expenses_with_children
    exs = expenses
    projects.each do |p|
      exs += p.expenses_with_children
    end
    return exs
  end
  
  def total_expense_with_children(ddd=nil)
    total_expense(ddd) + projects.collect {|p| p.total_expense_with_children(ddd)}.sum
  end
  
  def balance_with_children(ddd=nil)
    budget_amount.to_f - total_expense_with_children(ddd)
  end 
  
  def id_with_children
    tmp_ids = [id]
    projects.each do |p|
      tmp_ids += p.id_with_children
    end
    return tmp_ids.uniq
  end
  
  def time_plan(style=nil)
    if style.to_s == "thai"
      if from_date && to_date
        "#{from_date.to_s_thai} ถึง #{to_date.to_s_thai}"
      elsif from_date && to_date.nil?
        "#{from_date.to_s_thai}"
      elsif from_date.nil? && to_date
        "#{to_date.to_s_thai}"
      else
        "-"
      end
    else
      if from_date && to_date
        "#{from_date.to_s_lazy} - #{to_date.to_s_lazy}"
      elsif from_date && to_date.nil?
        "#{from_date.to_s_lazy}"
      elsif from_date.nil? && to_date
        "#{to_date.to_s_lazy}"
      else
        "-"
      end
    end
  end
  
  include Workflow
  workflow do
    state :new do
      event :submit, transitions_to: :enabled
      event :submit_as_draft, transitions_to: :draft
    end
    state :draft, meta: {no_destroy: true} do
      event :save_change, transitions_to: :enabled
      event :save_change_as_draft, transitions_to: :draft
      event :terminate, transitions_to: :terminated
      event :print, transitions_to: :draft
    end
    state :enabled, meta: {no_destroy: true} do
      event :save_change, transitions_to: :enabled
      event :save_change_as_draft, transitions_to: :draft
      event :project_approve, transitions_to: :project_approved
      event :change_to_draft, transitions_to: :draft
      event :terminate, transitions_to: :terminated
      event :print, transitions_to: :enabled
    end
    state :project_approved, meta: {no_destroy: true} do
      event :save_change, transitions_to: :project_approved
      event :change_to_enable, transitions_to: :enabled
      event :project_expense, transitions_to: :project_expensed
      event :print, transitions_to: :project_approved
    end
    state :project_expensed, meta: {no_destroy: true} do
      event :save_change, transitions_to: :project_expensed
      event :change_to_project_expense, transitions_to: :project_approved
      event :print, transitions_to: :project_expensed
      event :finish, transitions_to: :finished
    end
    state :finished, meta: {no_destroy: true, disabled: true} do
      event :reopen, transitions_to: :project_expensed
      event :print, transitions_to: :finished
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
    [:enabled, :project_approved, :project_expensed, :draft, :finished]
  end

  def self.form_action_events(action_name = nil)
    {
      new: [:submit, :submit_as_draft],
      create: [:submit, :submit_as_draft], 
      edit: [:save_change, :save_change_as_draft],
      update: [:save_change, :save_change_as_draft], 
      show: [:print, :enable, :change_to_draft, :change_to_enable, :change_to_project_expense, :project_approve, :project_expense, :close, :reopen, :terminate], 
      index: [:print, :enable, :reopen, :finish, :terminate]
    }[action_name.to_sym]
  end
  
  def terminate
    self.code = self.code + " #{Time.current.strftime("%Y%m%d%H%M")}"
    self.save
  end
  
end