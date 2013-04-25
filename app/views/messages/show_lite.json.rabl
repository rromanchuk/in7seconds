object @message
cache @message
attributes :id, :message, :created_at

node :from_user_id  do |message|
  message.from_user.id
end

node :to_user_id  do |message|
  message.to_user.id
end

node :is_from_self do |message|
  message.from_user == current_user ? true : false
end

