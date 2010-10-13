class TwitterAccount < ActiveRecord::Base

  has_many :tweets, :foreign_key => 'user_id', :order => 'twitter_id DESC'
  has_many :latest_50_tweets, :class_name => 'Tweet', :foreign_key => 'user_id', :order => 'twitter_id DESC', :limit => 50

  attr_reader :new_tweets

  before_validation :handle_empty_since_id

  validates_length_of :image_url, :maximum => 128
  validates_length_of :real_name, :maximum => 32
  validates_length_of :consumer_key,    :maximum => 32, :allow_nil => true
  validates_length_of :consumer_secret, :maximum => 64, :allow_nil => true
  validates_length_of :access_token,    :maximum => 64, :allow_nil => true
  validates_length_of :access_secret,   :maximum => 64, :allow_nil => true
  
  def fetch_tweets
    #tweets, self.since_id = Twitter::Status.from(self.user_id, :since_id => self.since_id)
    options = {}
    options[:since_id] = self.since_id if self.since_id
    result = Twitter.timeline(self.username, options)

    tweets = result.map{|obj| Tweet.from_status_json(obj)}
    self.since_id = tweets.map{|tweet| tweet.twitter_id}.max

    Rails.logger.info("== Received #{tweets.count} new tweets from #{self.username} ".ljust(80, '=')) unless tweets.empty?

    #  select those tweets, that are not yet stored in the database
    @new_tweets = tweets.select{|tweet| Tweet.find_by_twitter_id(tweet.twitter_id).nil?}

    # the following line might fail on postgres with: "incomplete multibyte character"
    # therefore we individually add every tweet, so we don't lose the other tweets

    #self.tweets << @new_tweets

    @new_tweets.each do |new_tweet|
      begin
        new_tweet.user = self             #  this line is needed!
        self.tweets.insert(new_tweet)     #  insert won't set user!! This could be a beta bug
        new_tweet.save
      rescue Exception => e
        Rails.logger.error "#{e.message}\nTweet: #{new_tweet.url}\n#{e.backtrace.join("\n")}"
        #Rails.logger.info(Marshal.dump(new_tweet).to_s)

        text_temp = new_tweet.text
        new_tweet.text = '*** failed to store string ***'
        new_tweet.save
        new_tweet.text = text_temp
      rescue Exception => e
        Rails.logger.error "#{e.message} (again!)\nTweet: #{new_tweet.url}\n#{e.backtrace.join("\n")}"
      end
    end

    self.save
  end

  def translate(from, to)
    ms_service_id = Service.find_by_symbol(:microsoft).id
    google_service_id = Service.find_by_symbol(:google).id

    # use the htmlentities gem to fix encoding for OS X
    coder = HTMLEntities.new

    @new_tweets.each do |tweet|

      ms_translation = Microsoft::Translator(tweet.text, from, to)
      ms_translation = coder.decode(ms_translation)
      tweet.store_translation(ms_translation, ms_service_id)

      google_translation = Translate.t(tweet.text, from, to)
      google_translation = coder.decode(google_translation)
      tweet.store_translation(google_translation, google_service_id)
    end
  end

  def tweet_translation(new_tweets)
    coder = HTMLEntities.new
    new_tweets.sort_by{|obj| obj.twitter_id}.each do |tweet|
      unless tweet.translated.blank?
        # http://luigimontanez.com/2010/rubyists-guide-twitter-oauth-dance/ was a good help
        oauth = Twitter::OAuth.new(self.consumer_key, self.consumer_secret)
        oauth.authorize_from_access(self.access_token, self.access_secret)

        client = Twitter::Base.new(oauth)
        client.update(coder.decode(tweet.translated[0,140]))
      end
    end
  end

  def to_s
    self.username
  end

  def handle_empty_since_id
    self.since_id = nil if self.since_id && self.since_id.to_s.empty?
  end

end
