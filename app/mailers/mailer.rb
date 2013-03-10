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

  def private_message(receiver, sender, message)
    @message = message
    mail to: receiver.email, :bcc => "support@in7seconds.com", subject: "#{sender.first_name} отправил вам сообщение."
  end

   def daily_stats
    @total_users = User.active.count
    @total_users_yesterday = User.added_yesterday.count
    @toal_ratings = Relationship.count
    @total_ratings_yesterday = Relationship.added_yesterday.count
    mail to: 'stats@piclar.com', subject: 'in7seconds Stats'
  end

end
