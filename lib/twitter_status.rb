require 'uri'
require 'json'
require 'net/http'
#require 'tweet'
require File.join(File.dirname(__FILE__), 'tweet')

module Twitter
  class Status

    #USER_TIMELINE_JSON_URL = 'http://api.twitter.com/1/statuses/user_timeline/yukihiro_matz.json'
    USER_TIMELINE_JSON_URL = 'http://api.twitter.com/1/statuses/user_timeline.json'

    def self.from(user_id, options = {})

      since_id = options.delete(:since_id)
      q_since = "&since_id=#{since_id}" if since_id

      url = "#{USER_TIMELINE_JSON_URL}?user_id=#{user_id}#{q_since}"
      uri = URI.parse(url)

      Logger.info("Connecting to #{url}")

      http_response = Net::HTTP.get(uri)

      Logger.debug("Response:\n#{http_response}")

      json_result = JSON.parse(http_response)

      tweet_array = json_result.collect{|obj| Tweet.from_status_json(obj)}
      max_id = json_result.max{|a,b| a['id'] <=> b['id']}

      # add some more info to the result
      class << tweet_array
        attr_accessor :max_id
      end

      tweet_array.max_id = max_id ? max_id['id'] : since_id

      tweet_array
    end
  end
end