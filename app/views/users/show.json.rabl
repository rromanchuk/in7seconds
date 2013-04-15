object @user
attributes :id, :vk_token, :fb_token, :authentication_token, :updated_at, :first_name, :last_name, :location, :birthday, :gender, :looking_for_gender, :email, :photo_url, :country, :city, :vk_domain

child @user.possible_hookups => :possible_hookups do 
  extends 'users/hookups'
end

# node :possible_hookups do |user|
#   user.possible_hookups.map do |hookup| 
#     partial("users/hookup_user", :object => hookup, :locals => { :current_user => current_user }) 
#   end
# end

child @user.hookups => :hookups do 
  extends 'users/matches'
end


# node :hookups do |user|
#   user.hookups.map do |hookup| 
#     partial("users/matches", :object => hookup, :locals => { :current_user => current_user }) 
#   end
# end


