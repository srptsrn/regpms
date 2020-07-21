class TicketCommentAttachment < ActiveRecord::Base
  belongs_to :ticket_comment
end
