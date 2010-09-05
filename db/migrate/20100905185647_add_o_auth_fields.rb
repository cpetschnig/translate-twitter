class AddOAuthFields < ActiveRecord::Migration
  def self.up
    add_column :twitter_accounts, :consumer_key,    :string, :limit => 32  # 22 should be enough
    add_column :twitter_accounts, :consumer_secret, :string, :limit => 64  # 41
    add_column :twitter_accounts, :access_token,    :string, :limit => 64  # 50
    add_column :twitter_accounts, :access_secret,   :string, :limit => 64  # 42
  end

  def self.down
    remove_column :twitter_accounts, :consumer_key
    remove_column :twitter_accounts, :consumer_secret
    remove_column :twitter_accounts, :access_token
    remove_column :twitter_accounts, :access_secret
  end
end
