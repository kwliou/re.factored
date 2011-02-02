# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Disable delivery errors, bad email addresses will be ignored
config.action_mailer.raise_delivery_errors = false

config.action_mailer.smtp_settings = {
  :address        => "smtp.sendgrid.net",
  :port           => 25,
  :authentication => :plain,
  :user_name      => "noreply@refactored.heroku.com",
  :password       => "dnklkssg",
  :domain         => "sendgrid.net"
}

config.action_mailer.perform_deliveries = false