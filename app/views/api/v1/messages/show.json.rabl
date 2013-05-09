object @message
cache @message
attributes :id, :message, :created_at

node :is_from_self do |message|
  message.from_user == current_user ? true : false
end

