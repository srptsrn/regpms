class EdpexKkuGroup < ActiveRecord::Base
  
  def to_s
    "#{no} #{name}".strip
  end
  
end
