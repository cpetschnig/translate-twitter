namespace :twitter do
  desc "Fetch new tweets and translate them"
  task :translate => :environment do
    TranslationJob.fetch_and_translate
  end

  desc "Fetch new tweets, translate them and tweet them"
  task :tweet_translation => :environment do
    TranslationJob.tweet_translation
  end
end
