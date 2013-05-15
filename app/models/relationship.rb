# encoding: utf-8
class Relationship < ActiveRecord::Base
  attr_accessible :user, :hookup, :status, :user_id, :hookup_id

  belongs_to :user
  belongs_to :hookup, :class_name => 'User'

  scope :added_yesterday, lambda { where(created_at: Date.yesterday...Date.today) }
  scope :matches, lambda { where(status: "accepted") }
  scope :matches_yesterday, lambda { added_yesterday.where(status: "accepted") }

  after_save :check_notify

  def check_notify
    if self.status_changed?
      changes = self.status_change
      if changes[1] == 'accepted'
        notify_match
      end
    end
  end

  def notify_match
    Notification.fuck(self.user, self.hookup)
    Notification.fuck(self.hookup, self.user)
    Mailer.fuck(self.user, self.hookup)
    Mailer.fuck(self.hookup, self.user)
  end
  handle_asynchronously :notify_match

  def notify_pending
    Notification.notify_requested_hookups(self)
    Mailer.pending_requests(self)
  end
  handle_asynchronously :notify_pending

  # send push notifications to users who have potential hookups waiting
  def self.notify_requested_hookups
    User.active.each do |user|
      requested = user.requested_that_user_may_like
      past_notifications = user.notifications.where(notification_type: Notification::NOTIFICATION_MATCH_REMINDER).where('created_at > ?', Time.now - 3.days)
      if !requested.blank? && past_notifications == 0
        user.notify_pending
      end
    end
  end

end
