Ada::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

end

Paperclip.options[:command_path] = "/opt/local/bin/" if `uname`.strip == "Darwin"
Paperclip.options[:command_path] = "/usr/bin/" if `uname`.strip == "Linux"

<<<<<<< HEAD
#OPENID_SERVER='http://178.79.149.181:81' # testada (somewhere in the UK)
OPENID_SERVER='http://users-test.ada.edu.au'
=======
# OPENID_SERVER='http://178.79.149.181:81'

OPENID_SERVER='http://falo.anu.edu.au:81' #olaf's machine

>>>>>>> master
