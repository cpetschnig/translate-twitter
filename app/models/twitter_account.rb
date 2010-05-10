class TwitterAccount < ActiveRecord::Base

  has_many :tweets, :foreign_key => 'user_id', :order => 'twitter_id DESC'
  has_many :latest_50_tweets, :class_name => 'Tweet', :foreign_key => 'user_id', :order => 'twitter_id DESC', :limit => 50

  attr_reader :new_tweets

  before_validation :handle_empty_since_id

  validates_length_of :image_url, :maximum => 128
  validates_length_of :real_name, :maximum => 32

  def fetch_tweets
    tweets, self.since_id = Twitter::Status.from(self.user_id, :since_id => self.since_id)

    Rails.logger.info("Received #{tweets.count} new tweets from #{self.username}.") unless tweets.empty?

    #  select those tweets, that are not yet stored in the database
    @new_tweets = tweets.select{|tweet| Tweet.find_by_twitter_id(tweet.twitter_id).nil?}

    # the following line might fail on postgres with: "incomplete multibyte character"
    #self.tweets << @new_tweets

    @new_tweets.each do |new_tweet|
      begin
        new_tweet.user = self             #  this line ist needed!
        self.tweets.insert(new_tweet)     #  insert won't set user!! This could be a beta bug
      rescue Exception => e
        puts "#{e}: #{e.message}\nTweet: #{new_tweet.url}\n#{e.backtrace}"
      end
    end

    self.save
  end

  def translate(from, to)
    ms_service_id = Service.find_by_symbol(:microsoft).id
    google_service_id = Service.find_by_symbol(:google).id

    @new_tweets.each do |tweet|

      ms_translation = Microsoft::Translator(tweet.text, from, to)
      tweet.store_translation(ms_translation, ms_service_id)

      google_translation = Translate.t(tweet.text, from, to)
      tweet.store_translation(google_translation, google_service_id)
      
#      begin
#        ms_translated = Microsoft::Translator(tweet.text, from, to)
#        tweet.translations << TweetTranslation.new(:service_id => ms_service_id, :text => ms_translated)
#        tweet.save
#      rescue Exception => e
#        puts "#{e}: #{e.message}\nTweet: #{tweet.url}\nTranslation: #{tweet.translations.map{|t|t.text}.join("\n")}\n#{e.backtrace.join("\n")}"
#      end
#      begin
#        google_translated = Translate.t(tweet.text, from, to)
#        tweet.translations << TweetTranslation.new(:service_id => google_service_id, :text => google_translated)
#        tweet.save
#      rescue Exception => e
#        puts "#{e}: #{e.message}\nTweet: #{tweet.url}\nTranslation: #{tweet.translations.map{|t|t.text}.join("\n")}\n#{e.backtrace.join("\n")}"
#      end
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
