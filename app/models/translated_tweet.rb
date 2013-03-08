class TranslatedTweet < ActiveRecord::Base
  self.table_name = "tweet_translations"

  belongs_to :tweet

  before_save :repair_translation

  validates :text, :length => {:maximum => 512}

  attr_accessible :text, :service_id

  private

  def repair_translation
    # check for twitter account translations: '@username' might have become '@ username'
    self.tweet.text.scan(/@[a-zA-Z0-9_]+/) do |match|
      # the translator likes to break twitter usernames
      # "@nari3" became "@ nari 3" or even "@ Nari 3"
      broken_username = match[1..-1].gsub(/(\d+)/, ' \1 ').strip
      self.text.gsub!(%r{@ (#{broken_username}|#{broken_username.capitalize})}, match)
    end
  end
end
