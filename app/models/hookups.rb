# encoding: utf-8
class Relationship < ActiveRecord::Base

  belongs_to :user
  belongs_to :hookup, :class_name => 'User'
end
