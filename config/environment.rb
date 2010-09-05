# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
TranslateTwitter::Application.initialize!


Toffee.configure '/tmp/translate-twitter.log'