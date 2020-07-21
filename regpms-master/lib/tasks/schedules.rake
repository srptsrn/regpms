# encoding: utf-8

namespace :schedules do
  
  task(:mail_test => :environment) do
    NotificationMailer.delay.mail_test
  end
  
end
