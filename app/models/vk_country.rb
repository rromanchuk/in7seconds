# encoding: utf-8
class VkCountry < ActiveRecord::Base
  validates :cid, :presence => {:message => 'city_id cannot be blank'}

  after_create :get_vk_country

  def get_vk_country
    response =  HTTParty.get('https://api.vk.com/method/getCountries', {query: {cids: cid, lang:"ru"}})
    if response
      self.name = response["response"].first["name"]
    end
    save
  end
  handle_asynchronously :get_vk_country, :priority => 20

  def self.update_missing
   VkCountry.where(name: nil).each do |c|
     c.get_vk_country
     sleep 3
   end
  end
  
end