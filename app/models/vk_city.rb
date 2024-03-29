# encoding: utf-8
class VkCity < ActiveRecord::Base
  after_create :get_vk_city
  validates :cid, :presence => {:message => 'city_id cannot be blank'}


  def get_vk_city
    response = HTTParty.get('https://api.vk.com/method/getCities', {query: {cids: cid, lang:"ru" }})
    if response && response["response"]
      puts response["response"].to_yaml + "<--------------------------"
      begin
        self.name = response["response"].first["name"] 
      rescue
      end
    end
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