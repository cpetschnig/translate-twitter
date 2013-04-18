# Handles translation of a tweet
class TranslationJob < ActiveRecord::Base

  belongs_to :source, :class_name => "TwitterAccount"
  belongs_to :target, :class_name => "TwitterAccount"

  validates :source_id, :presence => true

  scope :translate_only, where(:target_id => nil)
  scope :translate_and_tweet, where("target_id IS NOT NULL")

  # Fetches and translates the new tweets of all accounts, that have
  # no publishing account.
  def self.fetch_and_translate
    translate_only.each do |translation_job|
      translation_job.fetch_and_translate
    end
  end

  # Fetches the new tweets of the source account, translates them to the target
  # language using the Microsoft Translator and stores the translations.
  def fetch_and_translate
    ms_translator_service = Service.find_by_symbol(:microsoft)
    source.fetch_tweets.each do |tweet|
      if tweet.needs_translation?
        translation = Microsoft::Translator(tweet.text, from_lang, to_lang)
        tweet.store_translation(translation, ms_translator_service.id)
      end
    end
  end
end
