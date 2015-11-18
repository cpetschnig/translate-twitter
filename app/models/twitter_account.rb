# A user account at twitter.com
class TwitterAccount < ActiveRecord::Base

  has_many :tweets, :foreign_key => "user_id", :order => "twitter_id DESC"

  scope :consumers, where(:can_publish => false)
  scope :publishers, where(:can_publish => true)

  attr_accessible :username, :consumer_key, :consumer_secret, :access_token, :access_secret

  validates :username, :uniqueness => true
  validates :image_url, :length => {:maximum => 128}
  validates :real_name, :length => {:maximum => 32}
  validates :consumer_key,    :length => {:maximum => 32}, :allow_nil => true
  validates :consumer_secret, :length => {:maximum => 64}, :allow_nil => true
  validates :access_token,    :length => {:maximum => 64}, :allow_nil => true
  validates :access_secret,   :length => {:maximum => 64}, :allow_nil => true

  # Creates a new TwitterAccount object filled with the data from twitter.com
  def self.create_from_twitter(username)
    new.tap do |twitter_account|
      twitter_account.username = username
      twitter_account.update_user_data
    end
  end

  # Retrieve new tweets from Twitter and store them.
  # Sets :since_id to the Id of the newest tweet.
  # Returns new tweets.
  def fetch_tweets
    fetch_new_tweets_from_twitter.sort_by { |tweet| tweet.twitter_id }.tap do |tweets|
      if tweets.present?
        self.since_id = tweets.map(&:twitter_id).max
        self.tweets << tweets
        save
      end
    end
  end

  # Sync data from remote twitter with local object
  # TODO: reduce complexity for cane!
  def update_user_data
    result = TwitterClient.global.user(self.username)

    self.user_id = result.id
    self.created_at_twitter = result.created_at
    self.real_name = result.name
    self.followers = result.followers_count
    self.friends = result.friends_count
    self.statuses = result.statuses_count

    save
  end

  # Publish a status update (tweet) the given text
  def tweet(text)
    coder = HTMLEntities.new
    text_out = coder.decode(replace_at_chars(text)[0,140])
    TwitterClient.for_user(self).update(text_out)
  end

  # Retweet an existing tweet
  def retweet(tweet)
    TwitterClient.for_user(self).retweet(tweet.twitter_id)
  end

  private

  def fetch_new_tweets_from_twitter
    options = {}
    options[:since_id] = self.since_id if self.since_id

    TwitterClient.global.user_timeline(self.username, options).map do |raw_tweet|
      Tweet.from_twitter(raw_tweet)
    end
  end

  # Replace '@' chars
  def replace_at_chars(text)
    text.gsub(/@([a-zA-Z0-9_])/, '°\1')
  end
end
