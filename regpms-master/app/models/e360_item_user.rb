class E360ItemUser < ActiveRecord::Base
  belongs_to :e360_user
  belongs_to :e360_item
end
