# encoding: utf-8
class Relationship < ActiveRecord::Base
  attr_accessible :user, :hookup, :status, :user_id, :hookup_id
  
  belongs_to :user
  belongs_to :hookup, :class_name => 'User'
end