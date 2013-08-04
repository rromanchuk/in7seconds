object @user
cache ['authenticated_user', @user]
attributes :id, :authentication_token, :updated_at, :first_name, :last_name, :gender, :looking_for_gender, :email, :photo_url, :country, :city, :vk_domain, :email_opt_in, :push_opt_in, :latitude, :longitude, :fb_domain


node :birthday do |user|
  user.birthday_simple
end

child :images  do 
  extends "api/v1/images/show"
end