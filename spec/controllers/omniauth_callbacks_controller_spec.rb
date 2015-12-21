require "spec_helper"

describe OmniauthCallbacksController, :type => :controller do
  describe "#twitter" do

    before do
      credentials = OpenStruct.new(:token => "foo", :secret => "bar")
      allow(request).to receive(:env).and_return("omniauth.auth" => {"credentials" => credentials})
    end

    context "when user was found" do
      let(:user) { AdminUser.new }

      before do
        allow(AdminUser).to receive(:where).and_return [user]
      end

      it "should set a flash notice" do
        allow(controller).to receive(:sign_in_and_redirect)
        controller.twitter
        expect(flash[:notice]).to eq("Logged in Successfully")
      end

      it "should call sign_in_and_redirect" do
        expect(controller).to receive(:sign_in_and_redirect).with user
        controller.twitter
      end
    end

    context "when no user was found" do
      before do
        allow(AdminUser).to receive(:where).and_return []
      end

      it "should redirect to the registration page" do
        #get admin_root_path, :use_route => :active_admin
        allow(controller).to receive(:new_user_registration_path).and_return("new_user_registration_path")
        expect(controller).to receive(:redirect_to).with("new_user_registration_path")
        controller.twitter
      end
    end
  end
end
