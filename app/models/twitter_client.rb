require "twitter"

# A wrapper around the client of the twitter gem
# TODO: move to lib/
class TwitterClient

  # Returns the client used for global (read-only) actions.
  def self.global
    return @global if @global

    twitter_config = get_global_config

    @global = Twitter::REST::Client.new do |config|
      config.consumer_key        = twitter_config["consumer_key"]
      config.consumer_secret     = twitter_config["consumer_secret"]
      config.access_token        = twitter_config["global_access_token"]
      config.access_token_secret = twitter_config["global_access_token_secret"]
    end
  end

  # Returns the client for user-specific (write) actions.
  def self.for_user(user)
    Twitter::REST::Client.new do |config|
      config.consumer_key        = user.consumer_key
      config.consumer_secret     = user.consumer_secret
      config.access_token        = user.access_token
      config.access_token_secret = user.access_secret
    end
  end

  private

  def self.get_global_config
    filename = Rails.root + "config/twitter-oauth.yml"
    raise "#{filename} not found." unless File.exist?(filename)
    YAML::load(File.read(filename))
  end
end
