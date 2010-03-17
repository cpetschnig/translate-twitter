class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.integer :user_id
      t.integer :twitter_id, :limit => 8        # Twitter status id, BIGINT
      t.string :text
      t.string :irt_screen_name
      t.integer :irt_user_id
      t.string :irt_status_id
      t.string :contributors
      t.string :source
      t.boolean :favorited
      t.string :geo
      t.boolean :status
      t.string :json
      t.datetime :tw_created_at
      t.timestamps
    end
  end

  def self.down
    drop_table :tweets
  end
end
