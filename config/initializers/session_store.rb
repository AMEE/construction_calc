# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_overbury_session',
  :secret      => 'd502368646bafbca8832124ba18bebbe99939c7bb983e8ed0015eaa60c34304a26096cc70698f7f160f409ff73cb815ff7702ec19869457fb2dd29bf1b142888'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
