class AddIndicesToTables < ActiveRecord::Migration
  def change
    add_index "tweets", "twitter_id"
    add_index "tweet_translations", "tweet_id"
  end
end
