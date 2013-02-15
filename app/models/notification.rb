# encoding: utf-8
class Notification < ActiveRecord::Base
  belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"

  NOTIFICATION_TYPE_NO_EMAIL = 'no_email'
  NOTIFICATION_PRIVATE_MESSAGE = 'private_message'
  NOTIFICATION_MATCH = 'match'
  NOTIFICATION_MATCH_REMINDER = "match_reminder"
  NOTIFICATION_CUSTOM = "custom"
  # validates_inclusion_of :notification_type, :in => [NOTIFICATION_TYPE_NEW_COMMENT, NOTIFICATION_TYPE_NEW_FRIEND]

  attr_accessible :sender, :receiver, :notification_type, :sender_id, :receiver_id, :message
  
  def self.no_email(user)
    return unless user.push_opt_in?
    Notification.create(receiver_id: user.id, notification_type: NOTIFICATION_TYPE_NO_EMAIL, message: I18n.t('notifications.no_email'))
    Notification.send_notification!([user.id], I18n.t('notifications.no_email'), {type: NOTIFICATION_TYPE_NO_EMAIL})
  end

  def self.custom(hookup, message)
    return unless hookup.push_opt_in?
    Notification.create(receiver_id: hookup.id, notification_type: NOTIFICATION_CUSTOM, message: message)
    Notification.send_notification!([hookup.id], message, {type: NOTIFICATION_CUSTOM})
  end

  def self.private_message(sender, hookup, message)
    return unless hookup.push_opt_in?
    Notification.create(receiver_id: hookup.id, sender_id: sender.id, notification_type: NOTIFICATION_PRIVATE_MESSAGE, message: "#{sender.first_name}: #{message}")
    Notification.send_notification!([hookup.id], "#{sender.first_name}: #{message}", {type: NOTIFICATION_PRIVATE_MESSAGE, sender_id: sender.id})
  end
  
  def self.fuck(receiver, hookup)
    return unless receiver.push_opt_in?
    message = (hookup.gender) ? I18n.t('notifications.fuck.f', user: hookup.first_name) : I18n.t('notifications.fuck.m', user: hookup.first_name)
    Notification.create(receiver_id: receiver.id, sender_id: hookup.id, notification_type: NOTIFICATION_MATCH, message: message)
    Notification.send_notification!([receiver.id], message, {type: NOTIFICATION_MATCH, sender_id: hookup.id})
  end

  def self.notify_requested_hookups(receiver)
    return unless receiver.push_opt_in?
    num_requested = "#{receiver.requested_hookups.length}"
    people = (num_requested.to_i == 2) ? 'человека' : 'человек'
    message = I18n.t('notifications.pending_hookups', num_users: num_requested, people: people)
    Notification.create(receiver_id: receiver.id, notification_type: NOTIFICATION_MATCH_REMINDER, message: message)
    Notification.send_notification!([receiver.id], message, {type: NOTIFICATION_MATCH_REMINDER})
  end

  def self.send_notification!(aliases, message, extra={})
    #notification = { aliases: aliases.map(&:to_s), aps: {:alert => message, :badge => 1}, extra: extra }
    notification = { aliases: aliases.map(&:to_s), aps: {:alert => message, :badge => 1} }

    Urbanairship.push(notification)
    Mailer.delay.admin_notice(message)
  end


end