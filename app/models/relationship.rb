# encoding: utf-8
class Relationship < ActiveRecord::Base
  attr_accessible :user, :hookup, :status, :user_id, :hookup_id
  
  belongs_to :user
  belongs_to :hookup, :class_name => 'User'

  scope :added_yesterday, where(created_at: Date.yesterday...Date.today)
  scope :matches_yesterday, where(created_at: Date.yesterday...Date.today, status: "accepted")
  

  after_save :notify

  def notify
    if self.status_changed?
      changes = self.status_change
      if changes[1] == 'accepted'
        Notification.fuck(self.user, self.hookup)
        Notification.fuck(self.hookup, self.user)
        Mailer.delay.fuck(self.user, self.hookup)
        Mailer.delay.fuck(self.hookup, self.user)
      end
    end
  end

end