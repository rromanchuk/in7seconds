object false

node :withMatch do
  partial("users/some_partial", :object =>  @hookup }
end

node :id
  "#{current_user.id}#{@hookup.id}"
end

child @messages  do 
  extends "messages/show_lite"
end
