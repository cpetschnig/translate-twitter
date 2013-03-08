def get_google_analytics_id
  return nil unless Rails.env.production?

  filename = File.join(Rails.root, 'config', 'google-analytics.yml')

  unless File.exist?(filename)
    puts "#{filename} not found. Google Analytics will not be available!"
    return nil
  end

  yml_result = YAML::load(File.read(filename))
  yml_result['web_property_id']
end

GOOGLE_ANALYTICS_ID = get_google_analytics_id
