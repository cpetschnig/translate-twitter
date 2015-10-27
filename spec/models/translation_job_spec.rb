require "spec_helper"

describe TranslationJob do

  describe "associations" do
    it { expect(subject).to belong_to :source }
    it { expect(subject).to belong_to :target }
  end

  describe "mass assignment protection" do
    it { expect(subject).to allow_mass_assignment_of :source_id }
    it { expect(subject).to allow_mass_assignment_of :target_id }
    it { expect(subject).to allow_mass_assignment_of :from_lang }
    it { expect(subject).to allow_mass_assignment_of :to_lang }
    it { expect(subject).to allow_mass_assignment_of :active }
  end

  describe "validations" do
    it { expect(subject).to validate_presence_of :source_id }
  end

  describe ".fetch_and_translate" do
    it "should iterate over all active jobs that are for translation only" do
      translation_only_jobs = OpenStruct.new(:active => [])
      expect(described_class).to receive(:translate_only).and_return translation_only_jobs
      described_class.fetch_and_translate
    end

    it "should call :fetch_and_translate on every 'translation only' job" do
      translation_only_job = OpenStruct.new(fetch_and_translate: "translation_only_job")

      expect(translation_only_job).to receive(:fetch_and_translate)

      allow(described_class).to receive_message_chain(:translate_only, :active).and_return [translation_only_job]
      described_class.fetch_and_translate
    end
  end

  describe ".fetch_translate_and_tweet" do
    it "should iterate over all active jobs that are for translation and tweeting" do
      translate_and_tweet_jobs = OpenStruct.new(:active => [])

      expect(described_class).to receive(:translate_and_tweet).and_return translate_and_tweet_jobs

      described_class.fetch_translate_and_tweet
    end

    it "should call :fetch_translate_and_tweet on every 'translate and tweet' job" do
      translate_and_tweet_job = OpenStruct.new(fetch_translate_and_tweet: "translate_and_tweet_job")

      expect(translate_and_tweet_job).to receive(:fetch_translate_and_tweet)

      allow(described_class).to receive_message_chain(:translate_and_tweet, :active).and_return [translate_and_tweet_job]
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
      expect(subject.source).to receive(:fetch_tweets).and_return []
      subject.fetch_and_translate
    end

    it "should iterate over the fetched tweets" do
      pending()
      new_tweets = []
      expect(new_tweets).to receive(:each)
      expect(subject).to receive(:fetch_tweets).and_return new_tweets
      subject.fetch_and_translate
    end

    context "when it needs translation" do
      let :tweet do
        Tweet.new(:text => "foo bar").tap do |tweet|
          allow(tweet).to receive(:needs_translation?).and_return true
        end
      end

      it "should send the text of the tweet to the Microsoft Translator" do
        allow(tweet).to receive(:store_translation)
        allow(subject.source).to receive(:fetch_tweets).and_return [tweet]
        expect(Microsoft).to receive(:Translator).with(tweet.text, nil, nil)
        subject.fetch_and_translate
      end

      it "should store the translation with the tweet" do
        allow(subject.source).to receive(:fetch_tweets).and_return [tweet]
        allow(Microsoft).to receive(:Translator).and_return "some translation"
        expect(tweet).to receive(:store_translation).with("some translation", anything)
        subject.fetch_and_translate
      end
    end

    context "when it does not need translation" do
      let :tweet do
        Tweet.new(:text => "foo bar").tap do |tweet|
          allow(tweet).to receive(:needs_translation?).and_return false
        end
      end

      it "should not send the text of the tweet to the Microsoft Translator" do
        allow(subject.source).to receive(:fetch_tweets).and_return [tweet]
        expect(Microsoft).to_not receive(:Translator).with(tweet.text, nil, nil)
        subject.fetch_and_translate
      end

      it "should not store the translation with the tweet" do
        allow(subject.source).to receive(:fetch_tweets).and_return [tweet]
        expect(tweet).to_not receive(:store_translation).with("some translation", anything)
        subject.fetch_and_translate
      end
    end
  end

  describe "#fetch_translate_and_tweet" do
    subject do
      described_class.new.tap do |translation_job|
        translation_job.build_source
        translation_job.build_target
        allow(translation_job.target).to receive(:tweet)
      end
    end

    it "should fetch the tweets of the source account" do
      expect(subject.source).to receive(:fetch_tweets).and_return []
      subject.fetch_translate_and_tweet
    end

    it "should iterate over the fetched tweets" do
      new_tweets = []
      expect(new_tweets).to receive(:each)
      allow(subject.source).to receive(:fetch_tweets).and_return new_tweets
      subject.fetch_translate_and_tweet
    end

    context "when it needs translation" do
      let :tweet do
        Tweet.new(:text => "foo bar").tap do |tweet|
          allow(tweet).to receive(:needs_translation?).and_return true
        end
      end

      it "should send the text of the tweet to the Microsoft Translator" do
        allow(tweet).to receive(:store_translation)
        allow(subject.source).to receive(:fetch_tweets).and_return [tweet]

        expect(Microsoft).to receive(:Translator).with(tweet.text, nil, nil)
        subject.fetch_translate_and_tweet
      end

      it "should store the translation with the tweet" do
        allow(subject.source).to receive(:fetch_tweets).and_return [tweet]
        allow(Microsoft).to receive(:Translator).and_return "some translation"

        expect(tweet).to receive(:store_translation).with("some translation", anything)
        subject.fetch_translate_and_tweet
      end

      it "should tweet the translation with the target account" do
        allow(subject.source).to receive(:fetch_tweets).and_return [tweet]
        allow(Microsoft).to receive(:Translator).and_return "some translation"
        allow(tweet).to receive(:store_translation)

        expect(subject.target).to receive(:tweet).with("some translation")
        subject.fetch_translate_and_tweet
      end
    end

    context "when it does not need translation" do
      let :tweet do
        Tweet.new(:text => "foo bar").tap do |tweet|
          allow(tweet).to receive(:needs_translation?).and_return false
        end
      end

      it "should not send the text of the tweet to the Microsoft Translator" do
        allow(subject.source).to receive(:fetch_tweets).and_return [tweet]
        allow(subject.target).to receive(:retweet)

        expect(Microsoft).to_not receive(:Translator).with(tweet.text, nil, nil)
        subject.fetch_translate_and_tweet
      end

      it "should not store the translation with the tweet" do
        allow(subject.source).to receive(:fetch_tweets).and_return [tweet]
        allow(subject.target).to receive(:retweet)

        expect(tweet).to_not receive(:store_translation).with("some translation", anything)
        subject.fetch_translate_and_tweet
      end

      it "should retweet the tweet" do
        allow(subject.source).to receive(:fetch_tweets).and_return [tweet]
        expect(subject.target).to receive(:retweet).with(tweet)

        subject.fetch_translate_and_tweet
      end
    end
  end
end
