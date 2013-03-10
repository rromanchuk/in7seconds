class MailPreview < MailView
    # Pull data from existing fixtures
    def welcome
      user = User.first
      Mailer.welcome(user) 
    end

    def fuck
      user1 = User.first
      user2 = User.last
      Mailer.fuck(user1, user2)
    end

    def daily_stats
      Mailer.daily_stats
    end

    def private_message
      user1 = User.first
      user2 = User.last
      Mailer.private_message(user1, user2, "Hey, nice meeting you")
  end
end