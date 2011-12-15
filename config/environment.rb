# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem 'mysql'
  config.gem 'json'
  config.gem 'amee', :version => "~> 2.0.35"
  config.gem 'aasm'
  config.gem 'amee_rails_layer', :version => "~> 0.4.0"
  
  config.gem 'rspec', :lib => false, :version => "1.3.2"
  config.gem 'rspec-rails', :lib => false, :version => "1.3.2"
  config.gem 'shoulda', :lib => false
  config.gem "factory_girl"
  config.gem "will_paginate", :version => "~> 2.0"
  config.gem 'prawn', :version => "0.7.1"

  config.gem "airbrake", :version => '~> 3.0.5'

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Activate observers that should always be running
  config.active_record.observers = :user_observer, :password_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

end