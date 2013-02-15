object @private_message
#cache @message_object
attributes :id, :message

node :created_at do |message|
  message.created_at.strftime("%Y-%m-%dT%TZ")
end

node :is_from_self do |message|
  message.from_user == current_user ? true : false
end
