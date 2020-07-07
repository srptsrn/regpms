class EdpexKku < ActiveRecord::Base
  
  belongs_to :edpex_kku_group
  
  has_many :edpex_kku_items, -> {order("created_at")}
  accepts_nested_attributes_for :edpex_kku_items, :reject_if => :all_blank, :allow_destroy => true
  
  def to_s
    "#{no} #{name}".strip
  end
  
end
