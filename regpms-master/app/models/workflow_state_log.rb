class WorkflowStateLog < ActiveRecord::Base

  # after_create do |record|
    # a = record.creator.user_authorities.active.select{|a| a.creator.can? record.event.to_sym, record.resource_class.constantize }.first
    # record.update_column(:updater_id, a.creator.id) if a
  # end
  
end
