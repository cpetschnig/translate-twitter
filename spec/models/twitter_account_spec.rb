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
  end

  describe "#fetch_tweets" do
    it "should call :user_timeline on the global Twitter client object" do
      TwitterClient.global.should_receive(:user_timeline).and_return []
      subject.fetch_tweets
    end
  end
end
