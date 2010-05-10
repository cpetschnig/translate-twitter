class TranslationJob < ActiveRecord::Base
  belongs_to :source, :class_name => 'TwitterAccount'
  belongs_to :target, :class_name => 'TwitterAccount'

  validates :source, :presence => true
  validates_numericality_of :target, :allow_nil => true, :greater_than => 0

  def self.tweet_translation
    Microsoft::Translator.set_app_id(read_ms_app_id)
    TranslationJob.all(:conditions => 'target_id IS NOT NULL').each do |translation|
      translation.source.fetch_tweets
      translation.source.translate(translation.from_lang, translation.to_lang)
      translation.target.tweet_translation(translation.source.new_tweets)
    end
  end

  def self.fetch_and_translate
    Microsoft::Translator.set_app_id(read_ms_app_id)
    translations = TranslationJob.all(:conditions => 'target_id IS NULL')
    #Rails.logger.info("Translating #{translations.map{|t| t.source.username}.join(', ')} for website only.")
    translations.each do |translation|
      translation.source.fetch_tweets
      translation.source.translate(translation.from_lang, translation.to_lang)
    end
  end

  def self.read_ms_app_id
    filename = File.join(Rails.root, 'config', 'ms-translator.yml')
    yml_result = YAML::load(File.read(filename))
    yml_result['app_id']
  end

  def self.batch_translation_for(service_symbol)
  end
end
