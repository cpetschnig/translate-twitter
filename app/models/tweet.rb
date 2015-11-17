# A Tweet that is also stored at twitter.com
class Tweet < ActiveRecord::Base

  include FormattedTweet

  belongs_to :user, :class_name => "TwitterAccount"
  has_many :translations, :class_name => "TranslatedTweet" do
    # (pre-)load associations for a little performance boost
    def empty?
      proxy_association.length == 0
    end
  end

  attr_accessible :text, :twitter_id, :irt_screen_name, :irt_user_id, :irt_status_id, :source, :tw_created_at

  # Build a new instance from the object that was returned
  # by the client of the twitter gem.
  def self.from_twitter(obj)
    self.new(:text => obj.text,
             :twitter_id => obj.id,
             :irt_screen_name => obj.in_reply_to_screen_name.to_s,
             :irt_user_id => obj.in_reply_to_user_id,
             :irt_status_id => obj.in_reply_to_status_id.to_s,
             :source => obj.source,
             :tw_created_at => obj.created_at)
  end

  # Store a new translation
  def store_translation(translation, service_id=0)
    translations.create(:text => translation, :service_id => service_id)
  end

  # Returns true when the tweet actually needs to be translated
  # TODO: this concept fails, when the tweet contains 'normal' (non language specific) characters
  def needs_translation?
    text.size != text.bytesize
  end
end
