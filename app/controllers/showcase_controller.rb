class ShowcaseController < ApplicationController

  # GET /showcase
  # GET /showcase.xml
  def index
    @users = TwitterAccount.all(:conditions => {:can_publish => false},
      :order => 'followers DESC')
    @tweets = Tweet.all(:limit => 20, :order => 'twitter_id DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @showcase }
    end
  end

  # GET /showcase/:username
  def show_user
    @user = TwitterAccount.find_by_username(params[:username])

    @users = TwitterAccount.all(:conditions => {:can_publish => false},
      :order => 'followers DESC')

    @tweets = Tweet.all(:limit => 20, :conditions => {:user_id => @user.id},
      :order => 'twitter_id DESC')

    respond_to do |format|
      format.html { render :action => 'index' }
      format.xml  { render :xml => @showcase }
    end
  end
end
