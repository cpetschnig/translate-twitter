class AddAccountType < ActiveRecord::Migration
  def self.up
    add_column :twitter_accounts, :can_publish, :boolean
  end

  def self.down
    remove_column :twitter_accounts, :can_publish
  end
end
