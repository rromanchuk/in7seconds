object false


node :withMatch do
  partial("users/hookup_user", :object =>  @hookup )
end

node :id do
 @messages.first.thread_id
end

child @messages  do 
  extends "messages/show_lite"
end
