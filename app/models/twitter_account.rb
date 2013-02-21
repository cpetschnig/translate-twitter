class TwitterAccount < ActiveRecord::Base

  has_many :tweets, :foreign_key => "user_id", :order => "twitter_id DESC"

  scope :consumers, where(:can_publish => false)
  scope :publishers, where(:can_publish => true)

  validates :image_url, :length => {:maximum => 128}
  validates :real_name, :length => {:maximum => 32}
  validates :consumer_key,    :length => {:maximum => 32}, :allow_nil => true
  validates :consumer_secret, :length => {:maximum => 64}, :allow_nil => true
  validates :access_token,    :length => {:maximum => 64}, :allow_nil => true
  validates :access_secret,   :length => {:maximum => 64}, :allow_nil => true

end
