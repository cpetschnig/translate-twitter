namespace :twitter do
  desc "Fetch new tweets, translate them and tweet them"
  task :translate => :environment do
    TranslationJob.run
  end
end
