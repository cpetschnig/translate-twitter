namespace :twitter do
  desc "Fetch new tweets and translate them"
  task :translate => :environment do
    level = Rails.env == 'production' ? ::ActiveSupport::BufferedLogger::INFO : ::ActiveSupport::BufferedLogger::DEBUG
    logger = ::ActiveSupport::BufferedLogger.new(
      File.join(Rails.root, 'log', "#{Time.new.strftime('%Y-%m')}.rake.twitter.translate.#{Rails.env}.log"), level)
    logger.auto_flushing = true
    Rails.logger = logger
    TranslationJob.fetch_and_translate
  end

  desc "Fetch new tweets, translate them and tweet them"
  task :tweet_translation => :environment do
    level = Rails.env == 'production' ? ::ActiveSupport::BufferedLogger::INFO : ::ActiveSupport::BufferedLogger::DEBUG
    logger = ::ActiveSupport::BufferedLogger.new(
      File.join(Rails.root, 'log', "#{Time.new.strftime('%Y-%m')}.rake.twitter.tweet_translation.#{Rails.env}.log"), level)
    logger.auto_flushing = true
    Rails.logger = logger
    logger.info '** Starting rake twitter:tweet_translation '.ljust(80, '*')
    TranslationJob.fetch_translate_and_tweet
    logger.info '** Finished. '.ljust(80, '*')
  end
end
