require "spec_helper"

describe TwitterClient do

  describe ".global" do
    after :each do
      # undo caching
      described_class.instance_variable_set("@global", nil)
    end

    it "should return a Twitter::Client object" do
      expect(described_class.global).to be_a Twitter::Client
    end

    it "should raise an exception if the config/twitter-oauth.yml file does not exist" do
      described_class.instance_variable_set("@global", nil)
      allow(File).to receive(:exist?).and_return(false)
      expect { described_class.global }.to raise_exception(RuntimeError)
    end
  end

  describe ".for_user" do
    let(:user) { OpenStruct.new(:consumer_key => "A", :consumer_secret => "B", :access_token => "C", :access_secret => "D") }

    it "should return a Twitter::Client object" do
      expect(described_class.for_user(user)).to be_a Twitter::Client
    end
  end
end
