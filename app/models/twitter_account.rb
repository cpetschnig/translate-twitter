class TwitterAccount < ActiveRecord::Base

  has_many :tweets, :foreign_key => "user_id", :order => "twitter_id DESC"
end
