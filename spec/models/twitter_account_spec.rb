require "spec_helper"

describe TwitterAccount do

  describe "associations" do
    it { should have_many :tweets }
  end

  describe "scopes" do
    describe "consumers" do
      it "should load only those where :can_publish is false" do
        described_class.consumers.where_clauses.should include "`twitter_accounts`.`can_publish` = 0"
      end
    end

    describe "publishers" do
      it "should load only those where :can_publish is true" do
        described_class.publishers.where_clauses.should include "`twitter_accounts`.`can_publish` = 1"
      end
    end
  end

  describe "validations" do
    it { should ensure_length_of(:image_url).is_at_most(128) }
    it { should ensure_length_of(:real_name).is_at_most(32) }
    it { should ensure_length_of(:consumer_key).is_at_most(32) }
    it { should ensure_length_of(:consumer_secret).is_at_most(64) }
    it { should ensure_length_of(:access_token).is_at_most(64) }
    it { should ensure_length_of(:access_secret).is_at_most(64) }
    it { should validate_uniqueness_of(:username) }
  end

  describe ".create_from_twitter" do
    it "should set the given username" do
      object = described_class.new
      described_class.stub(:new).and_return object
      object.stub(:update_user_data)
      described_class.create_from_twitter("asdf")
      object.username.should == "asdf"
    end

    it "should update the account data from twitter" do
      object = described_class.new
      described_class.stub(:new).and_return object
      object.should_receive(:update_user_data)
      described_class.create_from_twitter("asdf")
    end
  end

  describe "#fetch_tweets" do
    let(:tweet_obj_from_client) { mock("tweet_obj_from_client") }
    let(:tweets_from_client) { [tweet_obj_from_client] }

    it "should call :user_timeline on the global Twitter client object" do
      TwitterClient.global.should_receive(:user_timeline).and_return []
      subject.fetch_tweets
    end

    it "should create Tweet objects from the client result" do
      TwitterClient.global.stub(:user_timeline).and_return tweets_from_client
      Tweet.should_receive(:from_twitter).with(tweet_obj_from_client).and_return Tweet.new
      subject.fetch_tweets
    end

    it "should set :since_id to the id of the newest tweet" do
      TwitterClient.global.stub(:user_timeline).and_return tweets_from_client
      Tweet.stub(:from_twitter).and_return Tweet.new(:twitter_id => 33)
      subject.fetch_tweets
      subject.since_id.should == 33
    end

    it "should return the new tweets" do
      new_tweet = Tweet.new(:twitter_id => 77)
      TwitterClient.global.stub(:user_timeline).and_return tweets_from_client
      Tweet.stub(:from_twitter).and_return new_tweet
      subject.fetch_tweets.should == [ new_tweet ]
    end
  end

  describe "#update_user_data" do
    let(:back_than) { Time.new(1939, 5, 1) }
    let :user_data_result do
      mock(:id => 33, :location => "Gotham City", :description => "Dark Knight",
           :created_at => back_than, :profile_image_url => "http://foo.bar/baz.png",
           :name => "Bruce Wayne", :followers_count => 15_000_001, :friends_count => 7, :statuses_count => 3)
    end

    it "should call :user on the global Twitter client object" do
      TwitterClient.global.should_receive(:user).and_return user_data_result
      subject.update_user_data
    end

    describe "attributes" do
      before do
        TwitterClient.global.stub(:user).and_return user_data_result
        subject.update_user_data
      end

      its(:user_id) { should == 33 }
      its(:location) { should == "Gotham City" }
      its(:description) { should == "Dark Knight" }
      its(:created_at_twitter) { should == back_than }
      its(:image_url) { should == "http://foo.bar/baz.png" }
      its(:real_name) { should == "Bruce Wayne" }
      its(:followers) { should == 15_000_001 }
      its(:friends) { should == 7 }
      its(:statuses) { should == 3 }
    end
  end
end
