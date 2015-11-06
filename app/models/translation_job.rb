# Handles translation of a tweet
class TranslationJob < ActiveRecord::Base

  belongs_to :source, :class_name => "TwitterAccount"
  belongs_to :target, :class_name => "TwitterAccount"

  attr_accessible :source_id, :target_id, :from_lang, :to_lang, :active

  validates :source_id, :presence => true

  scope :translate_only, where(:target_id => nil)
  scope :translate_and_tweet, where("target_id IS NOT NULL")
  scope :active, where(:active => true)

  # Fetches and translates the new tweets of all accounts that have
  # no publishing account.
  def self.fetch_and_translate
    translate_only.active.each do |translation_job|
      translation_job.fetch_and_translate
    end
  end

  # Fetches, translates and tweets the translation of all accounts
  # that do have an associated publishing account
  def self.fetch_translate_and_tweet
    translate_and_tweet.active.each do |translation_job|
      translation_job.fetch_translate_and_tweet
    end
  end

  # Fetches the new tweets of the source account, translates them to the target
  # language using the Microsoft Translator and stores the translations.
  def fetch_and_translate
    source.fetch_tweets.each do |tweet|
      if tweet.needs_translation?
        translation = translator.translate(tweet.text, from: from_lang, to: to_lang)
        tweet.store_translation(translation)
      end
    end
  end

  # Fetches the new tweets of the source account, translates them to the target
  # language using the Microsoft Translator and stores the translations.
  def fetch_translate_and_tweet
    source.fetch_tweets.each do |tweet|
      translation = nil
      if tweet.needs_translation?
        translation = translator.translate(tweet.text, from: from_lang, to: to_lang)
        tweet.store_translation(translation)
      end

      if tweet.needs_translation? #&& tweet.was_translated?
        target.tweet(translation)
      else
        target.retweet(tweet)
      end
    end
  end

  private

  def translator
    @translator ||= BingTranslator.new(Rails.configuration.bing_client_id, Rails.configuration.bing_client_secret)
  end
end
