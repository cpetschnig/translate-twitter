class AddLimitToAdminUserUid < ActiveRecord::Migration
  def change
    change_column :admin_users, :uid, :integer, limit: 5
  end
end
