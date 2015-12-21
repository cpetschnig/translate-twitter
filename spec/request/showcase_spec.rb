require "spec_helper"

describe "Showcase", :type => :request do
  describe "all" do
    it "should render the newest 20 tweets" do
      get url_for(:controller => "showcase", :action => "index")
    end
  end

  describe "user" do
    it "should render the newest 20 tweets of the given user" do
      pending
      get url_for(:controller => "showcase", :action => "show_user", :username => "yukihiro_matz")
    end
  end
end
