object @user
attributes :id, :vk_token, :fb_token, :authentication_token, :updated_at, :first_name, :last_name, :location, :birthday, :gender, :looking_for_gender, :email, :photo_url, :country, :city, :vk_domain

child @user.possible_hookups => :possible_hookups do 
  extends 'users/hookups'
end

child @user.hookups => :hookups do 
  extends 'users/matches'
end


