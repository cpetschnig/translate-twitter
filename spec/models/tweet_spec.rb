require "spec_helper"

describe Tweet do
  describe "translations" do
    describe ".empty?" do
      it "should override :empty? to not use the database COUNT method" do
        [described_class.column_names, TranslatedTweet.column_names]  # trigger "SHOW FIELDS FROM..." query
        query = "SELECT `tweet_translations`.* FROM `tweet_translations`  WHERE `tweet_translations`.`tweet_id` IS NULL"
        result = mock(Array, :fields => [], :to_a => [])
        ActiveRecord::Base.connection.should_receive(:execute).with(query, anything).and_return result
        subject.stub(:new_record?).and_return false
        subject.translations.empty?
      end
    end
  end
end
