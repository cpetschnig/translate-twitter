require "twitter"

# A wrapper around the client of the twitter gem
# TODO: move to lib/
class TwitterClient

  # Returns the client used for global (read-only) actions.
  def self.global
    return @global if @global

    twitter_config = get_global_config

    @global = Twitter::Client.new(
      :consumer_key => twitter_config["consumer_key"],
      :consumer_secret => twitter_config["consumer_secret"],
      :oauth_token => twitter_config["global_access_token"],
      :oauth_token_secret => twitter_config["global_access_token_secret"]
    )
  end

  private

  def self.get_global_config
    filename = Rails.root + "config/twitter-oauth.yml"
    raise "#{filename} not found." unless File.exist?(filename)
    YAML::load(File.read(filename))
  end
end
