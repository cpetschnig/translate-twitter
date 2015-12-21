require "spec_helper"

describe Tweet do

  it { should be_a FormattedTweet }

  describe "associations" do
    it { should belong_to :user }
    it { should have_many :translations }
  end

  describe "security" do
    it { expect(subject).to allow_mass_assignment_of :text }
    it { expect(subject).to allow_mass_assignment_of :twitter_id }
    it { expect(subject).to allow_mass_assignment_of :irt_screen_name }
    it { expect(subject).to allow_mass_assignment_of :irt_user_id }
    it { expect(subject).to allow_mass_assignment_of :irt_status_id }
    it { expect(subject).to allow_mass_assignment_of :source }
    it { expect(subject).to allow_mass_assignment_of :tw_created_at }
  end

  describe ".from_twitter" do
    let(:expected_timestamp) { 1.week.ago }
    let(:twitter_object) do
      OpenStruct.new(
        text: "abc",
        id: 23,
        in_reply_to_screen_name: "Foo",
        in_reply_to_user_id: 123,
        in_reply_to_status_id: 888,
        source: "Twitter for C64",
        created_at: expected_timestamp
      )
    end

    it "should take the attributes from the given object" do
      result = described_class.from_twitter(twitter_object)

      expect(result.text).to eq("abc")
      expect(result.twitter_id).to eq(23)
      expect(result.irt_screen_name).to eq("Foo")
      expect(result.irt_user_id).to eq(123)
      expect(result.irt_status_id).to eq(888)
      expect(result.source).to eq("Twitter for C64")
      expect(result.tw_created_at).to eq(expected_timestamp)
    end
  end

  describe "#store_translation" do
    it "should create a new translation" do
      expect(subject.translations).to receive(:create)
      subject.store_translation("foo bar", 1)
    end
  end

  describe "#needs_translation?" do
    it "should not need translation when it only has ascii chars" do
      tweet = Tweet.new(:text => "RT @peepcode: The best pairing since Robert Redford and Brad Pitt. " \
                                   "It's @tenderlove and @coreyhaines in the latest Play by Play! https:/ ...")
      expect(tweet.needs_translation?).to eq(false)
    end

    it "should not need translation when it has non-ascii, but ascii compatible chars" do
      pending
      # the "’", position 63 is Unicode
      tweet = Tweet.new(:text => "@nzkoz @steveklabnik @indirect Ya, I said we could CC there. " \
                                   "It’s 0 effort to add another CC. :-/")
      expect(tweet.needs_translation?).to eq(false)
    end

    it "should need translation when it has non-ascii chars" do
      tweet = Tweet.new(:text => "@lchin 終わったと言うか、負けたので降参して退社したんですが、降参しきれてなかったらしく。" \
                                   "いま、web から修正します。")
      expect(tweet.needs_translation?).to eq(true)
    end
  end
end
