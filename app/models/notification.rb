# encoding: utf-8
class Notification < ActiveRecord::Base
  belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"

  NOTIFICATION_TYPE_NO_EMAIL = 'no_email'
  NOTIFICATION_PRIVATE_MESSAGE = 'private_message'
  NOTIFICATION_MATCH = 'match'

  # validates_inclusion_of :notification_type, :in => [NOTIFICATION_TYPE_NEW_COMMENT, NOTIFICATION_TYPE_NEW_FRIEND]

  attr_accessible :sender, :receiver, :notification_type, :sender_id, :receiver_id
  
  def self.no_email(user)
    Notification.create(receiver_id: user.id, notification_type: NOTIFICATION_TYPE_NO_EMAIL)
    Notification.send_notification!([user.id], I18n.t('notifications.no_email'))
  end

  def self.private_message(sender, hookup, message)
    Notification.create(receiver_id: user.id, sender_id: sender.id, notification_type: NOTIFICATION_PRIVATE_MESSAGE)
    Notification.send_notification!([hookup.id], "#{sender.first_name}: #{message}")
  end
  
  def self.fuck(receiver, hookup)
    Notification.create(receiver_id: user.id, sender_id: sender.id, notification_type: NOTIFICATION_MATCH)
    message = (hookup.gender) ? I18n.t('notifications.fuck.f', user: hookup.first_name) : I18n.t('notifications.fuck.m', user: hookup.first_name)
    Notification.send_notification!([receiver.id], message)
  end

  def self.notify_requested_hookups(receiver, num_requested)
    people = (num_requested.to_i == 2) ? 'человека' : 'человек'
    message = I18n.t('notifications.pending_hookups', num_users: num_requested, people: people)
    Notification.send_notification!([receiver.id], message)
  end

  def self.send_notification!(aliases, message, extra={})
    notification = { aliases: aliases.map(&:to_s), aps: {:alert => message, :badge => 1}, extra: extra }
    Urbanairship.push(notification)
  end


end