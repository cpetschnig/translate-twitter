class AddLimitToTwitterClientsUserIds < ActiveRecord::Migration
  def change
    change_column :twitter_accounts, :user_id, :integer, limit: 5
    change_column :tweets, :irt_user_id, :integer, limit: 5
  end
end
