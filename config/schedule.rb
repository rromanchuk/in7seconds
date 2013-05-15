
every 5.day, :at => '4:30 am' do
  runner "User.update_friends"
end

every 1.day, :at => '8:30 am' do
  runner "Relationship.notify_requested_hookups"
end

every 1.day, at: '8:00 am' do
  rake 'mailer:send_daily_stats', :environment => :production
end