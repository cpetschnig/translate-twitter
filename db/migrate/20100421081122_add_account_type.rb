class AddAccountType < ActiveRecord::Migration
  def self.up
    add_column :twitter_accounts, :can_publish, :boolean
    change_column :tweet_translations, :text, :string, :limit => 512
  end

  def self.down
    remove_column :twitter_accounts, :can_publish
  end
end
