# encoding: utf-8
class Notification < ActiveRecord::Base
  # belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
  # belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"

  # validates_inclusion_of :notification_type, :in => [NOTIFICATION_TYPE_NEW_COMMENT, NOTIFICATION_TYPE_NEW_FRIEND]

  # attr_accessible :sender, :receiver, :notification_type, :sender_id, :receiver_id

  def self.no_email
    
  end
  
  def self.fuck(user1, user2)
    Notification.send_notfication!([user1.id, user2.id], "match was found")
    Mailer.fuck(user1, user2).deliver
    Mailer.fuck(user2, user1).deliver
  end

  def self.send_notfication!(aliases, message, extra={})
    notification = { aliases: aliases, aps: {:alert => message, :badge => 1}, extra: extra }
    Urbanairship.push(notification)
  end



end