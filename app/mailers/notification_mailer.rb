# encoding: utf-8
class NotificationMailer < ActionMailer::Base

  default from: "noreply@outputstream.net"
  
  def mail_test
    
    recievers = []
    # recievers << "batt_coe12@hotmail.com"
    recievers << "ibatt.in.th@gmail.com"
    
    mail(from: $EMAIL_DOMAIN, to: recievers, subject: "REGPMS :: Test")
  end
  
  def create_ticket(ticket)
    @ticket = ticket
    emails = @ticket.users.collect {|u| u.email} + [@ticket.creator.email]
    mail(from: $EMAIL_DOMAIN, to: emails, subject: 'New ticket :: ' + @ticket.no)
  end
  
  def reply_ticket(ticket_comment)
    @ticket_comment = ticket_comment
    @ticket = @ticket_comment.ticket
    emails = @ticket.users.collect {|u| u.email} + [@ticket.creator.email]
    mail(from: $EMAIL_DOMAIN, to: emails, subject: 'Reply ticket :: ' + @ticket.no)
  end
  
  def director_confirm(evaluation_user_final)
    @evaluation_user_final = evaluation_user_final
    @director = evaluation_user_final.director
    @user = evaluation_user_final.user
    @evaluation = evaluation_user_final.evaluation

    emails = [@user.email]
    cc_emails = [@director.email]
    
    mail(from: $EMAIL_DOMAIN, to: emails, cc: cc_emails, subject: "ผู้อำนวยการยืนยันข้อตกลง #{@user.prefix_firstname_lastname}")
  end
  
  def user_confirm(evaluation_user_final)
    @evaluation_user_final = evaluation_user_final
    @director = evaluation_user_final.director
    @user = evaluation_user_final.user
    @evaluation = evaluation_user_final.evaluation

    emails = [@director.email]
    cc_emails = [@user.email]
    
    mail(from: $EMAIL_DOMAIN, to: emails, cc: cc_emails, subject: "#{@user.prefix_firstname_lastname} รับทราบข้อตกลง ")
  end
  
end
