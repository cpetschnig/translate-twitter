class TwitterAccountsController < ApplicationController
  
  layout 'backend', :except => :fetch_from_twitter

  # GET /twitter_accounts
  # GET /twitter_accounts.xml
  def index
    @twitter_accounts = TwitterAccount.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @twitter_accounts }
    end
  end

  # GET /twitter_accounts/1
  # GET /twitter_accounts/1.xml
  def show
    @twitter_account = TwitterAccount.find(params[:id])

    respond_to do |format|
      format.html { render 'show' }
      format.xml  { render :xml => @twitter_account }
    end
  end

  # GET /twitter_accounts/new
  # GET /twitter_accounts/new.xml
  def new
    @twitter_account = TwitterAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @twitter_account }
    end
  end

  # GET /twitter_accounts/1/edit
  def edit
    @twitter_account = TwitterAccount.find(params[:id])
  end

  # POST /twitter_accounts
  # POST /twitter_accounts.xml
  def create
    @twitter_account = TwitterAccount.new(params[:twitter_account])

    respond_to do |format|
      if @twitter_account.save
        format.html { redirect_to(@twitter_account, :notice => 'TwitterAccount was successfully created.') }
        format.xml  { render :xml => @twitter_account, :status => :created, :location => @twitter_account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @twitter_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /twitter_accounts/1
  # PUT /twitter_accounts/1.xml
  def update
    @twitter_account = TwitterAccount.find(params[:id])

    respond_to do |format|
      if @twitter_account.update_attributes(params[:twitter_account])
        format.html { redirect_to(@twitter_account, :notice => 'TwitterAccount was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @twitter_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /twitter_accounts/1
  # DELETE /twitter_accounts/1.xml
  def destroy
    @twitter_account = TwitterAccount.find(params[:id])
    @twitter_account.destroy

    respond_to do |format|
      format.html { redirect_to(twitter_accounts_url) }
      format.xml  { head :ok }
    end
  end

  # GET /twitter_accounts/fetch_from_twitter
  def fetch_from_twitter
    @user = Twitter::User.fetch(params[:user])
    respond_to do |format|
      if @user
        format.html { render 'show_twitter' }
      else
        format.html { render :text => '<div>Twitter user was not found</div>', :status => :not_found }
      end
    end
  end
end
