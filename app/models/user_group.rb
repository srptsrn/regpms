# encoding: utf-8
require 'role_model'

class UserGroup < ActiveRecord::Base
  
  has_many :users
  
  validates :name, presence: true, uniqueness: true
  
  def to_s
    name
  end

  # RoleModel ######################################################################
  include RoleModel
  roles User::ROLES #- User::XROLES

  def authorized_as?(roles)
    athr = false
    roles.each do |role|
      athr = athr || self.send("#{role}?")
    end
    return athr
  end
  
  def role_names
    roles.collect {|r| r}
  end
  
  def role_names_join
    role_names.join(', ')
  end

end
