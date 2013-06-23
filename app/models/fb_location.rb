# encoding: utf-8
class FbLocation < ActiveRecord::Base
  #after_create :get_vk_city
  validates :lid, :presence => {:message => 'city_id cannot be blank'}
end