ActiveAdmin.register TwitterAccount do

  scope :all, :default => true
  scope :publishers
  scope :consumers

  index do
    selectable_column
    column "Image", :image_url do |account|
      image_tag(account.image_url, :height => 24, :width => 24) if account.image_url
    end
    column :username
    column "Joined on", :sortable => :created_at_twitter do |account|
      account.created_at_twitter && account.created_at_twitter.strftime("%Y-%m-%d")
    end
    column :can_publish
    column :real_name
    column :followers
    column "Actions" do |account|
      link_to("View", admin_twitter_account_path(account),
              :class => "member_link view_link") +
        link_to("Fetch Tweets", fetch_tweets_admin_twitter_account_path(account),
                :method => :post, :class => "member_link") +
        link_to("Update", update_data_admin_twitter_account_path(account),
                :method => :post, :class => "member_link")
    end
  end

  config.sort_order = "followers_desc"

  member_action :fetch_tweets, :method => :post do
    account = TwitterAccount.find(params[:id])
    account.fetch_tweets
    redirect_to url_for(:action => :show), :notice => "Fetched tweets of #{account.real_name} from Twitter."
  end

  member_action :update_data, :method => :post do
    account = TwitterAccount.find(params[:id])
    account.update_user_data
    redirect_to url_for(:action => :show), :notice => "Updated user data of #{account.real_name} from Twitter."
  end

  batch_action :update_user_data do |selection|
    TwitterAccount.find(selection).each do |account|
      account.update_user_data
    end
    redirect_to collection_path, :notice => "User data was updated."
  end

  # overwrite the default create action
  collection_action :create, :method => :post do
    twitter_account = TwitterAccount.create_from_twitter(params["twitter_account"]["username"])
    if twitter_account.valid?
      redirect_to admin_twitter_account_path(twitter_account), :notice => "New account was created!"
    else
      redirect_to collection_path, :alert => twitter_account.errors.full_messages
    end
  end

  form do |f|
    f.inputs "Details" do
      f.input :username
    end
    f.actions
  end
end
