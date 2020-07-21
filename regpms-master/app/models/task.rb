# encoding: utf-8

class Task < ActiveRecord::Base
  
  GROUPS = [
    Struct.new(:name, :klass, :weight, :sorting).new("ภารกิจประจำกลุ่มงาน", JobRoutine, 60, 1), 
    Struct.new(:name, :klass, :weight, :sorting).new("ภารกิจรอง/ภาระงานที่ได้รับมอบหมาย", JobVice, 10, 2), 
    Struct.new(:name, :klass, :weight, :sorting).new("ภารกิจอื่นตามภารกิจสำนักฯและมหาวิทยาลัย", JobPlan, 10, 3), 
    Struct.new(:name, :klass, :weight, :sorting).new("การพัฒนาองค์ความรู้และพัฒนางาน", JobDevelopment, 20, 4)
  ]
  
  scope :all_enabled, -> { order(:sorting).where(workflow_state: :enabled) }
  
  belongs_to :workflow_state_updater, class_name: "User"
  
  has_attached_file :file,
                    url: "/files/:class/:attachment/:id/:basename.:extension",
                    path: ":rails_root/public/files/:class/:attachment/:id/:basename.:extension"
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/
  
  validates :sorting, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  
  after_initialize do
    if self.new_record?
      self.sorting ||= (Task.last_sorting ? Task.last_sorting.sorting.to_i + 1 : 1)
    end
  end
  
  def to_s
    name
  end
  
  def self.last_sorting
    Task.limit(1).order("sorting DESC").first
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
