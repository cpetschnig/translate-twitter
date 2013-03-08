class TranslatedTweet < ActiveRecord::Base
  self.table_name = "tweet_translations"

  belongs_to :tweet

  validates :text, :length => {:maximum => 512}

  attr_accessible :text, :service_id
end
