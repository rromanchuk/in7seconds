# encoding: utf-8
class Group < ActiveRecord::Base
  attr_accessible :name, :photo

  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships
end