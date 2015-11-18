# The 'welcome' controller
class ShowcaseController < ApplicationController

  layout "showcase"

  before_filter :load_users

  # GET /showcase
  # GET /showcase.xml
  def index
    @tweets = Tweet.limit(20).order("twitter_id DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @showcase }
    end
  end

  # GET /:username
  def show_user
    if @user = TwitterAccount.find_by_username(params[:username])
      @tweets = Tweet.where(:user_id => @user.id).limit(20).order("twitter_id DESC")

      respond_to do |format|
        format.html { render :action => 'index' }
        format.xml  { render :xml => @showcase }
      end
    end
  end

  private

  def load_users
    @users = TwitterAccount.where(:can_publish => false).order('followers DESC')
  end
end
