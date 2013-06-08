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
    s_sent = (sender.gender == User::USER_MALE) ? "отправил" : "отправила"
    mail to: receiver.email, :bcc => "support@in7seconds.com", subject: "#{sender.first_name} #{s_sent} вам сообщение."
  end

  def pending_requests(receiver)
    return unless receiver.email_opt_in?
    @user = receiver
    @num_requested = receiver.requested_hookups.length
    @people = (@num_requested == 2) ? 'человека' : 'человек'
    mail to: receiver.email, :bcc => "support@in7seconds.com", subject: "Кто-то только что отметил тебя!"
  end

  def daily_stats
    @total_users = User.active.count
    @total_users_yesterday = User.added_yesterday.count
    @toal_ratings = Relationship.count
    @total_matches = Relationship.matches.count
    @matches_yesterday = Relationship.matches_yesterday.count
    @percent_female = User.active.women.length.to_f / User.active.length.to_f

    @total_ratings_yesterday = Relationship.added_yesterday.count
    @users_with_geo_location = User.with_geo_location.count
    @names_yesterday = User.active.added_yesterday.map(&:name).join(", ")
    @names = User.active.map(&:name).join(", ")
    mail to: 'stats@piclar.com', subject: 'in7seconds Stats'
  end

  def admin_notice(message)
    @message = message
    mail to: 'rromanchuk@gmail.com', subject: 'Notification sent'
  end

end
