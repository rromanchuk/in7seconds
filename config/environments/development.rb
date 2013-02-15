In7seconds::Application.configure do

  config.eager_load = false
  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict
  config.log_level = :debug

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.action_controller.asset_host = CONFIG[:asset_host]
  config.action_mailer.default_url_options = { :host => CONFIG[:asset_host] }

  Urbanairship.application_key = CONFIG[:ua_key]
  Urbanairship.application_secret = CONFIG[:ua_secret]
  Urbanairship.master_secret = CONFIG[:ua_master]
  Urbanairship.logger = Rails.logger
  Urbanairship.request_timeout = 5 # default

  Delayed::Worker.delay_jobs = false

  #config.action_mailer.delivery_method = :amazon_ses

  config.hamlcoffee.namespace = 'window.app.templates'
  #config.middleware.use MailView::Mapper, [MailPreview]

  Paperclip.options[:command_path] = "/usr/local/bin/"
  Paperclip.options[:log_command] = true
  
  config.after_initialize do
    Bullet.enable = false
    Bullet.alert = true 
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
  end
end
