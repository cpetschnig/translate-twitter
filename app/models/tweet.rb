class Tweet < ActiveRecord::Base

  belongs_to :user, :class_name => "TwitterAccount"
  has_many :translations, :class_name => "TranslatedTweet" do
    # (pre-)load associations for a little performance boost
    def empty?
      proxy_association.length == 0
    end
  end

end
