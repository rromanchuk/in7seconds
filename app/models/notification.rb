# encoding: utf-8
class Notification < ActiveRecord::Base
  # belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
  # belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"

  # validates_inclusion_of :notification_type, :in => [NOTIFICATION_TYPE_NEW_COMMENT, NOTIFICATION_TYPE_NEW_FRIEND]

  # attr_accessible :sender, :receiver, :notification_type, :sender_id, :receiver_id

  def self.no_email(user)
    Notification.send_notfication!([user.id], I18n.t('notifications.no_email'))
  end

  def self.private_message(hookup, message)
    Notification.send_notfication!([hookup.id], "#{hookup.first_name}: #{message}")
  end
  
  def self.fuck(receiver, hookup)
    message = (hookup.gender) ? I18n.t('notifications.fuck.f', user: hookup.first_name) : I18n.t('notifications.fuck.m', user: hookup.first_name)
    Notification.send_notfication!([receiver.id], message)
  end

  def self.send_notfication!(aliases, message, extra={})
    notification = { aliases: aliases, aps: {:alert => message, :badge => 1}, extra: extra }
    Urbanairship.push(notification)
  end



end