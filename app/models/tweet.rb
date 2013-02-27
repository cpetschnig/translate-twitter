class Tweet < ActiveRecord::Base

  belongs_to :user, :class_name => "TwitterAccount"
  has_many :translations, :class_name => "TranslatedTweet" do
    # (pre-)load associations for a little performance boost
    def empty?
      proxy_association.length == 0
    end
  end

  attr_accessible :text, :twitter_id, :irt_screen_name, :irt_user_id, :irt_status_id, :source, :tw_created_at

  def self.from_twitter(obj)
    self.new(:text => obj.text,
             :twitter_id => obj.id,
             :irt_screen_name => obj.in_reply_to_screen_name,
             :irt_user_id => obj.in_reply_to_user_id,
             :irt_status_id => obj.in_reply_to_status_id,
             :source => obj.source,
             :tw_created_at => obj.created_at)
  end
end
