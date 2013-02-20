class TranslatedTweet < ActiveRecord::Base
  self.table_name = "tweet_translations"

  belongs_to :tweet

  validates_length_of :text, :maximum => 512

end
