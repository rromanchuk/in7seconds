object @user
cache ['match_user', root_object]
attributes :id, :created_at, :first_name, :last_name, :gender, :email, :photo_url, :looking_for_gender, :country, :city, :vk_domain, :vk_university_name, :vk_graduation, :vk_faculty_name, :latitude, :longitude, :fb_domain


child :images  do 
  extends "api/v1/images/show"
end

node :birthday do |user|
  user.birthday_simple
end

node :mutual_friends_num do |user|
  user.mutual_friends_num(current_user)
end

node :mutual_friend_objects do |user|
  user.mutual_friends(current_user).map do |mutual_friend| 
    partial("api/v1/users/mutual_friend", :object => mutual_friend) 
  end
end

node :mutual_groups do |user|
  user.mutual_groups(current_user).length
end

node :mutual_friend_names do |user|
  current_user.mutual_friend_names(user)
end

node :mutual_group_names do |user|
  current_user.mutual_group_names(user)
end

node :friend_names do |user|
  user.friend_names
end

node :group_names do |user|
  user.group_names
end