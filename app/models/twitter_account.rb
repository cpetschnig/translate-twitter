class TwitterAccount < ActiveRecord::Base

  has_many :tweets, :foreign_key => "user_id", :order => "twitter_id DESC"

  scope :consumers, where(:can_publish => false)
  scope :publishers, where(:can_publish => true)

  validates :image_url, :length => {:maximum => 128}
  validates :real_name, :length => {:maximum => 32}
  validates :consumer_key,    :length => {:maximum => 32}, :allow_nil => true
  validates :consumer_secret, :length => {:maximum => 64}, :allow_nil => true
  validates :access_token,    :length => {:maximum => 64}, :allow_nil => true
  validates :access_secret,   :length => {:maximum => 64}, :allow_nil => true

  def fetch_tweets
    options = {}
    options[:since_id] = self.since_id if self.since_id
    result = TwitterClient.global.user_timeline(self.username, options)

    tweets = result.map { |obj| Tweet.from_twitter(obj) }
    self.since_id = tweets.map(&:twitter_id).max unless tweets.empty?

    self.tweets << tweets

    save
  end

  def update_user_data
    result = TwitterClient.global.user(self.username)

    self.image_url = result.profile_image_url
    self.real_name = result.name
    self.followers = result.followers_count

    save
  end
end
