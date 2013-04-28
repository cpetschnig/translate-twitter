set :output, File.expand_path("../../logs/cron_log.log", __FILE__)

every 2.minutes do
   rake "twitter:tweet_translation"
end

every 30.minutes do
   rake "twitter:translate"
end
