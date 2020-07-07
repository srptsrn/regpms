class Assessment < ActiveRecord::Base
  
  scope :all_enabled, -> { order(nil).where(["workflow_state = ?", :enabled]) }
  
  belongs_to :workflow_state_updater, class_name: "User"
  belongs_to :user
  belongs_to :evaluation
  belongs_to :committee, class_name: "User"
  
  validates :user, presence: true
  validates :evaluation, presence: true
  validates :committee, presence: true
  validates :role, presence: true
  
  def score111_weight
    35.0
  end
  
  def score112_weight
    35.0
  end
  
  def score113_weight
    10.0
  end
  
  def score114_weight
    20.0
  end
  
  def score211_weight
    9.090909
  end
  
  def score212_weight
    9.090909
  end
  
  def score213_weight
    9.090909
  end
  
  def score214_weight
    9.090909
  end
  
  def score215_weight
    9.090909
  end
  
  def score221_weight
    9.090909
  end
  
  def score222_weight
    9.090909
  end
  
  def score223_weight
    9.090909
  end
  
  def score224_weight
    9.090909
  end
  
  def score225_weight
    9.090909
  end
  
  def score226_weight
    9.090909
  end
  
  # expect
  def score211_expect
    3
  end
  
  def score212_expect
    3
  end
  
  def score213_expect
    3
  end
  
  def score214_expect
    3
  end
  
  def score215_expect
    3
  end
  
  def score221_expect
    3
  end
  
  def score222_expect
    3
  end
  
  def score223_expect
    3
  end
  
  def score224_expect
    3
  end
  
  def score225_expect
    3
  end
  
  def score226_expect
    3
  end
  
  # real
  def score111_real
    score111.to_i > 0 ? score111_real / score111 : 0
  end
  
  def score112_real
    score112.to_i > 0 ? score112_real / score112 : 0
  end
  
  def score113_real
    score113.to_i > 0 ? score113_real / score113 : 0
  end
  
  def score114_real
    score114.to_i > 0 ? score114_real / score114 : 0
  end
  
  def score211_real
    score211.to_i > 0 ? score211_real / score211 : 0
  end
  
  def score212_real
    score212.to_i > 0 ? score212_real / score212 : 0
  end
  
  def score213_real
    score213.to_i > 0 ? score213_real / score213 : 0
  end
  
  def score214_real
    score214.to_i > 0 ? score214_real / score214 : 0
  end
  
  def score215_real
    score215.to_i > 0 ? score215_real / score215 : 0
  end
  
  def score221_real
    score221.to_i > 0 ? score221_real / score221 : 0
  end
  
  def score222_real
    score222.to_i > 0 ? score222_real / score222 : 0
  end
  
  def score223_real
    score223.to_i > 0 ? score223_real / score223 : 0
  end
  
  def score224_real
    score224.to_i > 0 ? score224_real / score224 : 0
  end
  
  def score225_real
    score225.to_i > 0 ? score225_real / score225 : 0
  end
  
  def score226_real
    score226.to_i > 0 ? score226_real / score226 : 0
  end
  
  # real_expect
  def score211_real_expect
    score211.to_i >= 3 ? 3 : score211.to_i
  end
  
  def score212_real_expect
    score212.to_i >= 3 ? 3 : score212.to_i
  end
  
  def score213_real_expect
    score213.to_i >= 3 ? 3 : score213.to_i
  end
  
  def score214_real_expect
    score214.to_i >= 3 ? 3 : score214.to_i
  end
  
  def score215_real_expect
    score215.to_i >= 3 ? 3 : score215.to_i
  end
  
  def score221_real_expect
    score221.to_i >= 3 ? 3 : score221.to_i
  end
  
  def score222_real_expect
    score222.to_i >= 3 ? 3 : score222.to_i
  end
  
  def score223_real_expect
    score223.to_i >= 3 ? 3 : score223.to_i
  end
  
  def score224_real_expect
    score224.to_i >= 3 ? 3 : score224.to_i
  end
  
  def score225_real_expect
    score225.to_i >= 3 ? 3 : score225.to_i
  end
  
  def score226_real_expect
    score226.to_i >= 3 ? 3 : score226.to_i
  end
  
  # real_100
  def score211_real_100
    score211_expect.to_i > 0 ? (score211_real_expect / score211_expect) * 100 : 0
  end
  
  def score212_real_100
    score212_expect.to_i > 0 ? (score212_real_expect / score212_expect) * 100 : 0
  end
  
  def score213_real_100
    score213_expect.to_i > 0 ? (score213_real_expect / score213_expect) * 100 : 0
  end
  
  def score214_real_100
    score214_expect.to_i > 0 ? (score214_real_expect / score214_expect) * 100 : 0
  end
  
  def score215_real_100
    score215_expect.to_i > 0 ? (score215_real_expect / score215_expect) * 100 : 0
  end
  
  def score221_real_100
    score221_expect.to_i > 0 ? (score221_real_expect / score221_expect) * 100 : 0
  end
  
  def score222_real_100
    score222_expect.to_i > 0 ? (score222_real_expect / score222_expect) * 100 : 0
  end
  
  def score223_real_100
    score223_expect.to_i > 0 ? (score223_real_expect / score223_expect) * 100 : 0
  end
  
  def score224_real_100
    score224_expect.to_i > 0 ? (score224_real_expect / score224_expect) * 100 : 0
  end
  
  def score225_real_100
    score225_expect.to_i > 0 ? (score225_real_expect / score225_expect) * 100 : 0
  end
  
  def score226_real_100
    score226_expect.to_i > 0 ? (score226_real_expect / score226_expect) * 100 : 0
  end
  
  # total
  def score1_weight_total
    score111_weight.to_f + score112_weight.to_f + score113_weight.to_f + score114_weight.to_f 
  end
  
  def score1_real_total
    score111_real.to_f + score112_real.to_f + score113_real.to_f + score114_real.to_f 
  end
  
  def score2_weight_total
    100
    # score211_weight.to_f + score212_weight.to_f + score213_weight.to_f + score214_weight.to_f + score215_weight.to_f + 
    # score221_weight.to_f + score222_weight.to_f + score223_weight.to_f + score224_weight.to_f + score225_weight.to_f +  score226_weight.to_f
  end
  
  def score2_real_total
    score211_real.to_f + score212_real.to_f + score213_real.to_f + score214_real.to_f + score215_real.to_f + 
    score221_real.to_f + score222_real.to_f + score223_real.to_f + score224_real.to_f + score225_real.to_f +  score226_real.to_f 
  end
  
  include Workflow
  workflow do
    state :new do
      event :submit, transitions_to: :enabled
    end
    state :enabled, meta: {no_destroy: true} do
      event :save_change, transitions_to: :enabled
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
  
end
