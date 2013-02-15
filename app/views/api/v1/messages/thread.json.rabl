object false


node :with_match do
  partial("api/v1/users/match_user", :object =>  @hookup )
end

node :id do
 @messages.first.thread_id
end

child @messages  do 
  extends "api/v1/messages/show_old"
end
