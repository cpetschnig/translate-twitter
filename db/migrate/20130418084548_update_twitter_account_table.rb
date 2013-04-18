class UpdateTwitterAccountTable < ActiveRecord::Migration
  def up
    remove_column :twitter_accounts, :tweets_fetched_at
    add_column :twitter_accounts, :created_at_twitter, :datetime
    add_column :twitter_accounts, :location, :string
    add_column :twitter_accounts, :description, :string
    add_column :twitter_accounts, :friends, :integer
    add_column :twitter_accounts, :statuses, :integer
    add_index :twitter_accounts, :username, :unique => true
  end

  def down
    add_column :twitter_accounts, :tweets_fetched_at, :datetime
    remove_column :twitter_accounts, :created_at_twitter
    remove_column :twitter_accounts, :location
    remove_column :twitter_accounts, :description
    remove_column :twitter_accounts, :friends
    remove_column :twitter_accounts, :statuses
    remove_index :twitter_accounts, :username
  end
end
