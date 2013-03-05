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

  end