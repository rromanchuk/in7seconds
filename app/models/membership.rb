# encoding: utf-8
class Membership < ActiveRecord::Base
  attr_accessible :user_id, :group_id
  belongs_to :user
  belongs_to :group
end