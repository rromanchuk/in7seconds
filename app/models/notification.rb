# encoding: utf-8
class Notification < ActiveRecord::Base
  # belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
  # belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"

  # validates_inclusion_of :notification_type, :in => [NOTIFICATION_TYPE_NEW_COMMENT, NOTIFICATION_TYPE_NEW_FRIEND]

  # attr_accessible :sender, :receiver, :notification_type, :sender_id, :receiver_id

  def self.no_email(user)
    Notification.send_notfication!([user.id], "Упс, у тебя не введен адрес эл. почты. Введи его в настройках приложения чтобы сразу получать оповещения.")
  end

  def self.send_message(hookup, message)
    Notification.send_notfication!([hookup.id], "#{hookup.first_name}:#{message}")
  end
  
  def self.fuck(user1, user2)
    Notification.send_notfication!([user1.id, user2.id], "Ого, похоже что ты понравился <User>. Напиши (ему|ей) прямо сейчас!")
    Mailer.fuck(user1, user2).deliver
    Mailer.fuck(user2, user1).deliver
  end

  def self.send_notfication!(aliases, message, extra={})
    notification = { aliases: aliases, aps: {:alert => message, :badge => 1}, extra: extra }
    Urbanairship.push(notification)
  end



end