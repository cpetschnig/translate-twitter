require "spec_helper"

describe OmniauthCallbacksController do
  describe "#twitter" do

    before do
      credentials = mock(:token => "foo", :secret => "bar")
      request.stub(:env).and_return("omniauth.auth" => {"credentials" => credentials})
    end

    context "when user was found" do
      let(:user) { AdminUser.new }

      before do
        AdminUser.stub(:where).and_return [user]
      end

      it "should set a flash notice" do
        controller.stub(:sign_in_and_redirect)
        controller.twitter
        flash[:notice].should == "Logged in Successfully"
      end

      it "should call sign_in_and_redirect" do
        controller.should_receive(:sign_in_and_redirect).with user
        controller.twitter
      end
    end

    context "when no user was found" do
      before do
        AdminUser.stub(:where).and_return []
      end

      it "should redirect to the registration page" do
        #get admin_root_path, :use_route => :active_admin
        controller.stub(:new_user_registration_path).and_return("new_user_registration_path")
        controller.should_receive(:redirect_to).with("new_user_registration_path")
        controller.twitter
      end
    end
  end
end
