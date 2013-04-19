require "spec_helper"

describe TranslationJob do

  describe "associations" do
    it { should belong_to :source }
    it { should belong_to :target }
  end

  describe "mass assignment protection" do
    it { should allow_mass_assignment_of :source_id }
    it { should allow_mass_assignment_of :target_id }
    it { should allow_mass_assignment_of :from_lang }
    it { should allow_mass_assignment_of :to_lang }
    it { should allow_mass_assignment_of :active }
  end

  describe "validations" do
    it { should validate_presence_of :source_id }
  end

  describe ".fetch_and_translate" do
    it "should iterate over all active jobs that are for translation only" do
      translation_only_jobs = mock(:active => [])
      described_class.should_receive(:translate_only).and_return translation_only_jobs
      described_class.fetch_and_translate
    end

    it "should call :fetch_and_translate on every 'translation only' job" do
      translation_only_job = mock("translation_only_job")
      translation_only_job.should_receive(:fetch_and_translate)
      described_class.stub_chain(:translate_only, :active).and_return [translation_only_job]
      described_class.fetch_and_translate
    end
  end

  describe ".fetch_translate_and_tweet" do
    it "should iterate over all active jobs that are for translation and tweeting" do
      translate_and_tweet_jobs = mock(:active => [])
      described_class.should_receive(:translate_and_tweet).and_return translate_and_tweet_jobs
      described_class.fetch_translate_and_tweet
    end

    it "should call :fetch_translate_and_tweet on every 'translate and tweet' job" do
      translate_and_tweet_job = mock("translate_and_tweet_job")
      translate_and_tweet_job.should_receive(:fetch_translate_and_tweet)
      described_class.stub_chain(:translate_and_tweet, :active).and_return [translate_and_tweet_job]
      described_class.fetch_translate_and_tweet
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

    context "when it needs translation" do
      let :tweet do
        Tweet.new(:text => "foo bar").tap do |tweet|
          tweet.stub(:needs_translation?).and_return true
        end
      end

      it "should send the text of the tweet to the Microsoft Translator" do
        tweet.stub(:store_translation)
        subject.source.stub(:fetch_tweets).and_return [tweet]
        Microsoft.should_receive(:Translator).with(tweet.text, nil, nil)
        subject.fetch_and_translate
      end

      it "should store the translation with the tweet" do
        subject.source.stub(:fetch_tweets).and_return [tweet]
        Microsoft.stub(:Translator).and_return "some translation"
        tweet.should_receive(:store_translation).with("some translation", anything)
        subject.fetch_and_translate
      end
    end

    context "when it does not need translation" do
      let :tweet do
        Tweet.new(:text => "foo bar").tap do |tweet|
          tweet.stub(:needs_translation?).and_return false
        end
      end

      it "should not send the text of the tweet to the Microsoft Translator" do
        subject.source.stub(:fetch_tweets).and_return [tweet]
        Microsoft.should_not_receive(:Translator).with(tweet.text, nil, nil)
        subject.fetch_and_translate
      end

      it "should not store the translation with the tweet" do
        subject.source.stub(:fetch_tweets).and_return [tweet]
        tweet.should_not_receive(:store_translation).with("some translation", anything)
        subject.fetch_and_translate
      end
    end
  end

  describe "#fetch_translate_and_tweet" do
    subject do
      described_class.new.tap do |translation_job|
        translation_job.build_source
        translation_job.build_target
        translation_job.target.stub(:tweet)
      end
    end

    it "should fetch the tweets of the source account" do
      subject.source.should_receive(:fetch_tweets).and_return []
      subject.fetch_translate_and_tweet
    end

    it "should iterate over the fetched tweets" do
      new_tweets = []
      new_tweets.should_receive(:each)
      subject.source.stub(:fetch_tweets).and_return new_tweets
      subject.fetch_translate_and_tweet
    end

    context "when it needs translation" do
      let :tweet do
        Tweet.new(:text => "foo bar").tap do |tweet|
          tweet.stub(:needs_translation?).and_return true
        end
      end

      it "should send the text of the tweet to the Microsoft Translator" do
        tweet.stub(:store_translation)
        subject.source.stub(:fetch_tweets).and_return [tweet]
        Microsoft.should_receive(:Translator).with(tweet.text, nil, nil)
        subject.fetch_translate_and_tweet
      end

      it "should store the translation with the tweet" do
        subject.source.stub(:fetch_tweets).and_return [tweet]
        Microsoft.stub(:Translator).and_return "some translation"
        tweet.should_receive(:store_translation).with("some translation", anything)
        subject.fetch_translate_and_tweet
      end

      it "should tweet the translation with the target account" do
        subject.source.stub(:fetch_tweets).and_return [tweet]
        Microsoft.stub(:Translator).and_return "some translation"
        tweet.stub(:store_translation)
        subject.target.should_receive(:tweet).with("some translation")
        subject.fetch_translate_and_tweet
      end
    end

    context "when it does not need translation" do
      let :tweet do
        Tweet.new(:text => "foo bar").tap do |tweet|
          tweet.stub(:needs_translation?).and_return false
        end
      end

      it "should not send the text of the tweet to the Microsoft Translator" do
        subject.source.stub(:fetch_tweets).and_return [tweet]
        Microsoft.should_not_receive(:Translator).with(tweet.text, nil, nil)
        subject.fetch_translate_and_tweet
      end

      it "should not store the translation with the tweet" do
        subject.source.stub(:fetch_tweets).and_return [tweet]
        tweet.should_not_receive(:store_translation).with("some translation", anything)
        subject.fetch_translate_and_tweet
      end
    end
  end
end
