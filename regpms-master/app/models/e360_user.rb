class E360User < ActiveRecord::Base
  belongs_to :workflow_state_updater
  belongs_to :evaluation
  belongs_to :user
  belongs_to :committee
end
