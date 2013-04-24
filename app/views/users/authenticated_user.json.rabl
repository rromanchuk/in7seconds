object @user
cache @user
attributes :id, :vk_token, :fb_token, :authentication_token, :updated_at, :first_name, :last_name, :gender, :looking_for_gender, :email, :photo_url, :country, :city, :vk_domain


node :birthday do |user|
  user.birthday_simple
end