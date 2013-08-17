object @user
cache ['show_user', @user]
attributes :id, :updated_at, :first_name, :last_name, :gender, :looking_for_gender, :email, :photo_url, :country, :city, :vk_domain, :email_opt_in, :push_opt_in, :fb_domain, :status


node :birthday do |user|
  user.birthday_simple
end

child :images  do 
  extends "api/v1/images/show"
end