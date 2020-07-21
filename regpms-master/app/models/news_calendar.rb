class NewsCalendar < ActiveRecord::Base
  
  scope :front_published, -> { limit(5).order("published_at DESC").where(["workflow_state = ?", "published"]) }
  scope :all_published, -> { order("published_at DESC").where(["workflow_state = ?", "published"]) }
  
  belongs_to :workflow_state_updater, class_name: "User"
  
  after_initialize do 
    if self.new_record?
      self.published_at ||= Time.current
    end
  end
  
  include Workflow
  workflow do
    state :new do
      event :submit, transitions_to: :published
    end
    state :published, meta: {no_destroy: true} do
      event :save_change, transitions_to: :published
      event :unpublish, transitions_to: :unpublished
      event :terminate, transitions_to: :terminated
    end
    state :unpublished, meta: {no_destroy: true} do
      event :save_change, transitions_to: :unpublished
      event :publish, transitions_to: :published
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
    [:new, :published, :unpublished]
  end

  def self.form_action_events(action_name = nil)
    {
      new: [:submit],
      create: [:submit], 
      edit: [:save_change],
      update: [:save_change,], 
      show: [:publish, :unpublish, :terminate], 
      index: [:publish, :unpublish, :terminate]
    }[action_name.to_sym]
  end
  
end
