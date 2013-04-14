object @message
cache @message

attributes :id, :message, :created_at

child :from_user => :from_user do
  extends "users/hookup_user"
end

child :to_user => :to_user do
  extends "users/hookup_user"
end

