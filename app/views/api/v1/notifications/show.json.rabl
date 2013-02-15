object @notification
cache ['show_notification', root_object]
attributes :id, :created_at, :message, :is_read, :notification_type


child :sender => :sender do |user|
  if user
    user = current_user.hookups.where(id: user).first
    extends "api/v1/users/match_user", :object =>  user
  else
    ''
  end
  
end