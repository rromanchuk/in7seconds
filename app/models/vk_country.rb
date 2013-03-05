# encoding: utf-8
class VkCountry < ActiveRecord::Base
  after_create :get_vk_country

  def get_vk_country
    self.name = HTTParty.get('https://api.vk.com/method/getCountries', {query: {cids: cid}})["response"].first["name"]
    save
  end
  handle_asynchronously :get_vk_country, :priority => 20
end