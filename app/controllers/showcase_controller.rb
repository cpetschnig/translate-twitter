class ShowcaseController < ApplicationController

  layout 'frontend'

  # GET /showcase
  # GET /showcase.xml
  def index
    #@showcase = Showcase.all

    @users = TwitterAccount.all(:conditions => {:can_publish => false})
    @tweets = Tweet.all(:limit => 50, :order => 'twitter_id DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @showcase }
    end
  end

  # GET /showcase/:username
  def show_user

    @user = TwitterAccount.find_by_username(params[:username])
    #@showcase = Showcase.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @showcase }
    end
#  rescue Exception => e
#    render :text => e.message
  end
end
