object @message
#cache @message_object
attributes :id, :message

node :created_at do |message|
  message.created_at.strftime("%Y-%m-%dT%TZ")
end

node :is_from_self do |message|
  message.from_user == current_user ? true : false
end

node :with_match do |message|
  #logger.error thread.inspect
  if message.from_user == current_user
    @hookup = message.to_user
  else
    @hookup = message.from_user
  end
  @hookup = current_user.hookups.where(id: @hookup).first
  unless @hookup
    ''
  else
    partial("api/v1/users/match_user", :object =>  @hookup )
  end
  
end

node :user do
  partial("api/v1/users/authenticated_user", :object =>  current_user )
end

