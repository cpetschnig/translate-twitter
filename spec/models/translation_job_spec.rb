require "spec_helper"

describe TranslationJob do

  describe "associations" do
    it { should belong_to :source }
    it { should belong_to :target }
  end

  describe "validations" do
    it { should validate_presence_of :source_id }
  end

  describe ".fetch_and_translate" do
    it "should iterate over all jobs that are for translation only" do
      described_class.should_receive(:translate_only).and_return []
      described_class.fetch_and_translate
    end

    it "should call :fetch_and_translate on every 'translation only' job" do
      translation_only_job = mock("translation_only_job")
      translation_only_job.should_receive(:fetch_and_translate)
      described_class.stub(:translate_only).and_return [translation_only_job]
      described_class.fetch_and_translate
    end
  end

  describe "#fetch_and_translate" do
    subject do
      described_class.new.tap do |translation_job|
        translation_job.build_source
      end
    end

    it "should fetch the tweets of the source account" do
      subject.source.should_receive(:fetch_tweets).and_return []
      subject.fetch_and_translate
    end

    it "should iterate over the fetched tweets" do
      new_tweets = []
      new_tweets.should_receive(:each)
      subject.source.stub(:fetch_tweets).and_return new_tweets
      subject.fetch_and_translate
    end

    it "should send the text of the tweet to the Microsoft Translator" do
      tweet = mock("tweet", :text => "foo bar", :store_translation => true)
      subject.source.stub(:fetch_tweets).and_return [tweet]
      Microsoft.should_receive(:Translator).with(tweet.text, nil, nil)
      subject.fetch_and_translate
    end

    it "should store the translation with the tweet" do
      tweet = Tweet.new
      subject.source.stub(:fetch_tweets).and_return [tweet]
      Microsoft.stub(:Translator).and_return "some translation"
      tweet.should_receive(:store_translation).with("some translation", anything)
      subject.fetch_and_translate
    end
  end
end
