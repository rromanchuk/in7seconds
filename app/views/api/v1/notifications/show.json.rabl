object @notification
cache ['show_notification', root_object]
attributes :id, :created_at, :message, :is_read, :notification_type


child :sender => :sender do |user|
  extends "api/v1/users/match_user"
end