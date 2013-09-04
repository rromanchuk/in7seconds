# class FixDeactivatedUsers < ActiveRecord::Migration
#   def change
#     User.where(is_active: false).find_each do |friend|
#       puts friend.photo_url
#       unless User.photo_url_is_good?(friend.photo_url)
#         puts "BAD USER BAD USER DELETE THIS SHIT"
#         friend.destroy
#         sleep 2
#       end
#     end
#   end
# end
