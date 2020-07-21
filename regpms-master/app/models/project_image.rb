class ProjectImage < ActiveRecord::Base
  
  belongs_to :workflow_state_updater, class_name: "User"
  belongs_to :project
  
  has_attached_file :image, styles: { xlarge: "1920x1080>", large: "1024x1024>", medium: "500x500>", small: "300x300>", xsmall: "150x150>", thumb: "100x100>", avatar: "36x36#", row: "26x26#" },
                    convert_options: {
                      medium: "-gravity center -extent 500x500",
                      small: "-gravity center -extent 300x300",
                      xsmall: "-gravity center -extent 150x150",
                      thumb: "-gravity center -extent 100x100"
                    },
                    url: "/files/:class/:attachment/:id/:style/:basename.:extension",
                    path: ":rails_root/public/files/:class/:attachment/:id/:style/:basename.:extension", 
                    default_url: "/files/missing/:class/:style.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  
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