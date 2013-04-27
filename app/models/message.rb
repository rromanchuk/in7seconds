class Message < ActiveRecord::Base
  attr_accessible :from_user, :to_user, :message, :thread_id

  belongs_to :from_user,  :class_name => 'User' # from_user_id field fk Users
  belongs_to :to_user,    :class_name => 'User' # to_user_id field fk Users
  belongs_to :thread, :class_name => 'Message'  # Reference to parent message
  has_many :replies,  :class_name => 'Message', :foreign_key => 'thread_id'

  after_create :notify, :update_thread_id
  #named_scope :in_reply_to, lambda { |message| :conditions => {:thread => message}, :order => 'created_at' }

  def self.first_message(current_user, hookup)
    Message.where('(from_user_id = ? AND to_user_id = ?) OR (to_user_id = ? AND from_user_id = ?)', hookup.id, current_user.id, hookup.id, current_user.id).first
  end

  def first_message
    first_message = Message.where('(from_user_id = ? AND to_user_id = ?) OR (to_user_id = ? AND from_user_id = ?)', from_user.id, to_user.id, to_user.id, from_user.id).first
    logger.error "found first message to update thread id " + first_message.inspect

    if first_message
      first_message
    else
      self
    end
  end

  def self.thread(current_user, hookup)
    Message.where('(from_user_id = ? AND to_user_id = ?) OR (to_user_id = ? AND from_user_id = ?)', hookup.id, current_user.id, hookup.id, current_user.id)
  end

  def thread
    Message.where(thread: self)
  end

  def notify
    Notification.private_message(self.from_user, self.to_user, self.message)
    Mailer.delay.private_message(to_user, from_user, message)
  end
  
  def update_thread_id
    update_attributes(thread_id: first_message.id)
  end
end