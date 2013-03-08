class Message < ActiveRecord::Base
  belongs_to :from_user,  :class_name => 'User' # from_user_id field fk Users
  belongs_to :to_user,    :class_name => 'User' # to_user_id field fk Users
  belongs_to :thread, :class_name => 'Message'  # Reference to parent message
  has_many :replies,  :class_name => 'Message', :foreign_key => 'thread_id'

  named_scope :in_reply_to, lambda { |message| :conditions => {:thread => message}, :order => 'created_at' }
end