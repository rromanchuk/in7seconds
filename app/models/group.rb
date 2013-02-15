# encoding: utf-8
class Group < ActiveRecord::Base
  attr_accessible :name, :photo

  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships

  def self.update_groups
    User.active.each do |u|
      u.get_groups
      sleep 2
    end
  end

end