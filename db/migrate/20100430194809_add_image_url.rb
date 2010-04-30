class AddImageUrl < ActiveRecord::Migration
  def self.up
    add_column :twitter_accounts, :image_url, :string, :limit => 128
    add_column :twitter_accounts, :real_name, :string, :limit => 32
  end

  def self.down
    remove_column :twitter_accounts, :image_url
    remove_column :twitter_accounts, :real_name
  end
end
