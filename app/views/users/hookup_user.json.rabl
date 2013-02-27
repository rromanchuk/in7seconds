object @user
attributes :id, :updated_at, :first_name, :last_name, :location, :birthday, :gender, :email, :photo_url, :looking_for_gender, :country, :city

node :mutual_friends do |user|
  user.mutual_friends(current_user).length
end

node :mutual_groups do |user|
  user.mutual_groups(current_user).length
end