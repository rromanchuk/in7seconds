object @user
attributes :id, :vk_token, :fb_token, :authentication_token, :updated_at, :first_name, :last_name, :location, :birthday, :gender, :looking_for_gender, :email, :photo_url, :country, :city, :vk_domain


node :possible_hookups do |user|
  user.possible_hookups.map do |hookup| 
    partial("users/hookup_user", :object => hookup) 
  end
end

node :hookups do |user|
  user.hookups.map do |hookup| 
    partial("users/hookup_user", :object => hookup) 
  end
end


node :mutal_friend_names do |user|
  user
end

node :mutual_group_names do |user|
  current_user.mutual_group_names(user)
end