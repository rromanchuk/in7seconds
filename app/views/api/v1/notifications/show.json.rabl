object @notification
cache @notification
attributes :id, :created_at, :message, :is_read, :notification_type


child @sender  do 
  extends "api/v1/users/match_user"
end