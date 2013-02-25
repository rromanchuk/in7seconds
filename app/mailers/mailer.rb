# encoding: utf-8
class Mailer < ActionMailer::Base
  default from: 'noreply@in7seconds.com'

  def welcome(user)
    mail to: user.email, bcc: "support@in7seconds.com", subject: 'Добро пожаловать в 7seconds'
  end

  def fuck(receiver, hookup)
    @params = {hookup: hookup, receiver: receiver}
    mail to: receiver.email, :bcc => "support@in7seconds.com", subject: "Ого, да вы понравились #{hookup.first_name}"
  end

end
