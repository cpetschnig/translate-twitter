require "spec_helper"

describe TwitterAccount do

  describe "associations" do
    it { expect(subject).to have_many :tweets }
  end

  describe "scopes" do
    describe "consumers" do
      it "should load only those where :can_publish is false" do
        expect(described_class.consumers.where_clauses).to include "\"twitter_accounts\".\"can_publish\" = 'f'"
      end
    end

    describe "publishers" do
      it "should load only those where :can_publish is true" do
        expect(described_class.publishers.where_clauses).to include "\"twitter_accounts\".\"can_publish\" = 't'"
      end
    end
  end

  describe "mass assignment protection" do
    it { expect(subject).to allow_mass_assignment_of :username }
    it { expect(subject).to allow_mass_assignment_of :consumer_key }
    it { expect(subject).to allow_mass_assignment_of :consumer_secret }
    it { expect(subject).to allow_mass_assignment_of :access_token }
    it { expect(subject).to allow_mass_assignment_of :access_secret }
  end

  describe "validations" do
    it { expect(subject).to validate_length_of(:image_url).is_at_most(128) }
    it { expect(subject).to validate_length_of(:real_name).is_at_most(32) }
    it { expect(subject).to validate_length_of(:consumer_key).is_at_most(32) }
    it { expect(subject).to validate_length_of(:consumer_secret).is_at_most(64) }
    it { expect(subject).to validate_length_of(:access_token).is_at_most(64) }
    it { expect(subject).to validate_length_of(:access_secret).is_at_most(64) }
    it { expect(subject).to validate_uniqueness_of(:username) }
  end

  describe ".create_from_twitter" do
    it "should set the given username" do
      object = described_class.new
      allow(described_class).to receive(:new).and_return object
      allow(object).to receive(:update_user_data)
      described_class.create_from_twitter("asdf")
      expect(object.username).to eq("asdf")
    end

    it "should update the account data from twitter" do
      object = described_class.new
      allow(described_class).to receive(:new).and_return object
      expect(object).to receive(:update_user_data)
      described_class.create_from_twitter("asdf")
    end
  end

  describe "#fetch_tweets" do
    let(:tweet_obj_from_client) { OpenStruct.new(tweet_obj_from_client: "tweet_obj_from_client") }
    let(:tweets_from_client) { [tweet_obj_from_client] }

    it "should call :user_timeline on the global Twitter client object" do
      expect(TwitterClient.global).to receive(:user_timeline).and_return []
      subject.fetch_tweets
    end

    it "should create Tweet objects from the client result" do
      allow(TwitterClient.global).to receive(:user_timeline).and_return tweets_from_client
      expect(Tweet).to receive(:from_twitter).with(tweet_obj_from_client).and_return Tweet.new
      subject.fetch_tweets
    end

    it "should set :since_id to the id of the newest tweet" do
      allow(TwitterClient.global).to receive(:user_timeline).and_return tweets_from_client
      allow(Tweet).to receive(:from_twitter).and_return Tweet.new(:twitter_id => 33)
      subject.fetch_tweets
      expect(subject.since_id).to eq(33)
    end

    it "should return the new tweets" do
      new_tweet = Tweet.new(:twitter_id => 77)
      allow(TwitterClient.global).to receive(:user_timeline).and_return tweets_from_client
      allow(Tweet).to receive(:from_twitter).and_return new_tweet
      expect(subject.fetch_tweets).to eq([ new_tweet ])
    end

    it "should store the tweets oldest first" do
      new_tweet_0 = Tweet.new(:twitter_id => 85)
      new_tweet_1 = Tweet.new(:twitter_id => 77)
      new_tweet_2 = Tweet.new(:twitter_id => 61)

      allow(subject).to receive(:fetch_new_tweets_from_twitter).and_return [new_tweet_0, new_tweet_1, new_tweet_2]
      subject.fetch_tweets
      expect(subject.tweets.last(3)).to eq([new_tweet_2, new_tweet_1, new_tweet_0])
    end
  end

  describe "#update_user_data" do
    let(:back_than) { Time.new(1939, 5, 1) }
    let :user_data_result do
      OpenStruct.new(:id => 33, :location => "Gotham City", :description => "Dark Knight",
           :created_at => back_than, :profile_image_url => "http://foo.bar/baz.png",
           :name => "Bruce Wayne", :followers_count => 15_000_001, :friends_count => 7, :statuses_count => 3)
    end

    it "should call :user on the global Twitter client object" do
      expect(TwitterClient.global).to receive(:user).and_return user_data_result
      subject.update_user_data
    end

    describe "attributes" do
      before do
        expect(TwitterClient.global).to receive(:user).and_return user_data_result
        subject.update_user_data
      end

      it "should have correct attributes" do
        expect(subject.user_id).to eq(33)
        expect(subject.location).to eq("Gotham City")
        expect(subject.description).to eq("Dark Knight")
        expect(subject.created_at_twitter).to eq(back_than)
        expect(subject.image_url).to eq("http://foo.bar/baz.png")
        expect(subject.real_name).to eq("Bruce Wayne")
        expect(subject.followers).to eq(15_000_001)
        expect(subject.friends).to eq(7)
        expect(subject.statuses).to eq(3)
      end
    end
  end

  describe "#tweet" do
    it "should use the oauth tokens of the twitter account" do
      pending "OpenStruct is not working here"
      client = OpenStruct.new(:update => nil)
      expect(TwitterClient).to receive(:for_user).with(subject).and_return client
      subject.tweet("foo")
    end

    it "should replace '@' chars with '°'" do
      client = OpenStruct.new
      allow(TwitterClient).to receive(:for_user).and_return client

      expect(client).to receive(:update).with("guilty °m_seki @ yotii23 °sferik?")
      subject.tweet("guilty @m_seki @ yotii23 @sferik?")
    end
  end

  describe "#retweet" do
    it "should use the oauth tokens of the twitter account" do
      pending "OpenStruct is not working here"
      client = OpenStruct.new()
      allow(TwitterClient).to receive(:for_user).with(subject).and_return client
      subject.retweet(Tweet.new)
    end

    it "should call the :retweet method on the client object" do
      client = OpenStruct.new
      expect(client).to receive(:retweet).with(1337)

      allow(TwitterClient).to receive(:for_user).and_return client
      subject.retweet(OpenStruct.new(:twitter_id => 1337))
    end
  end
end
