# encoding: utf-8
class VkCity < ActiveRecord::Base
  after_create :get_vk_city

  def get_vk_city
    self.name = HTTParty.get('https://api.vk.com/method/getCities', {query: {cids: cid}})["response"].first["name"]
    save
  end
  handle_asynchronously :get_vk_city, :priority => 20

  def self.update_missing
   VkCity.where(name: nil).each do |c|
     c.get_vk_city
     sleep 3
   end
  end
  
end