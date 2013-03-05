class MailPreview < MailView
    # Pull data from existing fixtures
    def welcome
      user = User.first
      Mailer.welcome(user) 
    end

  end