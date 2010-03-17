class CreateTwitterAccounts < ActiveRecord::Migration
  def self.up
    create_table :twitter_accounts do |t|
      t.string :username
      t.integer :user_id
      t.string :password
      t.string :since_id
      t.datetime :tweets_fetched_at
      t.timestamps
    end
  end

  def self.down
    drop_table :twitter_accounts
  end
end
