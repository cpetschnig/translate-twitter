class TwitterAccount < ActiveRecord::Base

  has_many :tweets, :foreign_key => 'user_id', :order => 'twitter_id DESC'

  attr_reader :new_tweets

  before_validation :handle_empty_since_id

  def fetch_tweets
    @new_tweets, self.since_id = Twitter::Status.from(self.user_id, :since_id => self.since_id)
    #@new_tweets.each{|tweet| tweet.user = self}    # I thought, rails would do this for me in the next line
    self.tweets << @new_tweets
    self.save
  end

  def translate(from, to)
    @new_tweets.each do |tweet|
      translated = Microsoft::Translator(tweet.text, from, to)
      tweet.translations << TweetTranslation.new(:service_id => 1, :text => translated)
      tweet.save
    end
  end

  def tweet_translation(new_tweets)
    new_tweets.sort do |a, b|
      a.twitter_id <=> b.twitter_id   # TODO: check order
    end.each do |tweet|
      Twitter::Status.tweet(self.username, self.password, tweet.translated)
    end
  end

  def to_s
    self.username
  end

  def handle_empty_since_id
    self.since_id = nil if self.since_id && self.since_id.to_s.empty?
  end
end
