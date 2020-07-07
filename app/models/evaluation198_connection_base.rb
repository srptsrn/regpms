class Evaluation198ConnectionBase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "evaluation198_database_#{Rails.env}"
end
