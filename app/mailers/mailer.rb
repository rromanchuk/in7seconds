# encoding: utf-8
class Mailer < ActionMailer::Base
  default from: 'noreply@in7seconds.com'

  def welcome(user)
    @user = user
    mail to: user.email, bcc: "support@in7seconds.com", subject: I18n.t('mail.welcome.subject')
  end

  def fuck(receiver, hookup)
    return unless receiver.email_opt_in?
    @user = receiver
    if receiver.email.blank?
      Notification.no_email(receiver)
      return
    end
    @params = {hookup: hookup, receiver: receiver}
    mail to: receiver.email, :bcc => "support@in7seconds.com", subject: "Ого, да вы понравились #{hookup.first_name}"
  end

  def private_message(receiver, sender, message)
    return unless receiver.email_opt_in?
    @user = receiver
    @message = message
    mail to: receiver.email, :bcc => "support@in7seconds.com", subject: "#{sender.first_name} отправил вам сообщение."
  end

   def daily_stats
    @total_users = User.active.count
    @total_users_yesterday = User.added_yesterday.count
    @toal_ratings = Relationship.count
    @total_matches = Relationship.matches_yesterday.count

    @total_ratings_yesterday = Relationship.added_yesterday.count
    @users_with_geo_location = User.with_geo_location.count
    @names = User.active.map(&:name).join(", ")

    mail to: 'stats@piclar.com', subject: 'in7seconds Stats'
  end

end
