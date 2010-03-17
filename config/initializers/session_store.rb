# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_translate-twitter_session',
  :secret => 'd6b38beae5e0052eabd588a4a019e145e441eb757b9d95844794b17d94c3b4d380d35db7e14c7483e23bfc228c5ab65aa413e306400abb3d36abec2f55285af7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
