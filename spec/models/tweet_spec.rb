require "spec_helper"

describe Tweet do

  describe "associations" do
    it { should belong_to :user }
    it { should have_many :translations }

    describe "translations" do
      describe ".empty?" do
        it "should override :empty? to not use the database COUNT method" do
          [described_class.column_names, TranslatedTweet.column_names]  # trigger "SHOW FIELDS FROM..." query
          query = "SELECT `tweet_translations`.* FROM `tweet_translations`  " \
                  "WHERE `tweet_translations`.`tweet_id` IS NULL"
          result = mock(Array, :fields => [], :to_a => [])
          ActiveRecord::Base.connection.should_receive(:execute).with(query, anything).and_return result
          subject.stub(:new_record?).and_return false
          subject.translations.empty?
        end
      end
    end
  end

  describe "security" do
    it { should allow_mass_assignment_of :text }
    it { should allow_mass_assignment_of :twitter_id }
    it { should allow_mass_assignment_of :irt_screen_name }
    it { should allow_mass_assignment_of :irt_user_id }
    it { should allow_mass_assignment_of :irt_status_id }
    it { should allow_mass_assignment_of :source }
    it { should allow_mass_assignment_of :tw_created_at }
  end

  describe ".from_twitter" do
    let :twitter_object do
      mock(:text => "abc", :id => 23, :in_reply_to_screen_name => "Foo",
           :in_reply_to_user_id => 123, :in_reply_to_status_id => 888,
           :source => "Twitter for C64", :created_at => expected_timestamp)
    end

    let(:expected_timestamp) { 1.week.ago }

    it "should take the attributes from the given object" do
      result = described_class.from_twitter(twitter_object)
      result.text.should == "abc"
      result.twitter_id.should == 23
      result.irt_screen_name.should == "Foo"
      result.irt_user_id.should == 123
      result.irt_status_id.should == 888
      result.source.should == "Twitter for C64"
      result.tw_created_at.should == expected_timestamp
    end
  end

  describe "#store_translation" do
    it "should create a new translation" do
      subject.translations.should_receive(:create)
      subject.store_translation("foo bar", 1)
    end
  end

  describe "#needs_translation?" do
    context "when has only ascii chars" do
      subject { Tweet.new(:text => "RT @peepcode: The best pairing since Robert Redford and Brad Pitt. " \
                                   "It's @tenderlove and @coreyhaines in the latest Play by Play! https:/ ...") }
      its(:needs_translation?) { should be_false }
    end

    context "when it has non-ascii, but ascii compatible chars" do
      # the "’", position 63 is Unicode
      subject { Tweet.new(:text => "@nzkoz @steveklabnik @indirect Ya, I said we could CC there. " \
                                   "It’s 0 effort to add another CC. :-/") }
      its(:needs_translation?) { pending; should be_false }
    end

    context "when it has non-ascii chars" do
      subject { Tweet.new(:text => "@lchin 終わったと言うか、負けたので降参して退社したんですが、降参しきれてなかったらしく。" \
                                   "いま、web から修正します。") }
      its(:needs_translation?) { should be_true }
    end
  end
end
