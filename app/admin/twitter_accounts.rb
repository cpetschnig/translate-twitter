ActiveAdmin.register TwitterAccount do

  scope :all, :default => true
  scope :publishers
  scope :consumers

  index do
    column :id
    column :username
    column :user_id
    column :can_publish
    column :real_name
    column :followers
    default_actions
  end

end
