require File.join Rails.root, 'app/models', 'twitter_status'
require File.join Rails.root, 'app/models', 'twitter_user'
require File.join Rails.root, 'app/models', 'constantrecords'

def get_google_analytics_id
  filename = File.join(Rails.root, 'config', 'google-analytics.yml')

  unless File.exist?(filename)
    puts "#{filename} not found. Google Analytics will not be avaliable!"
    return nil
  end

  yml_result = YAML::load(File.read(filename))
  yml_result['web_property_id']
end


GOOGLE_ANALYTICS_ID = get_google_analytics_id

