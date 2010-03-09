require 'uri'
require 'json'
require 'net/http'
require File.join(File.dirname(__FILE__), 'tweet')

module Twitter
  class Status

    USER_TIMELINE_JSON_URL = 'http://api.twitter.com/1/statuses/user_timeline.json'

    def self.from(user_id, options = {})

      since_id = options.delete(:since_id)
      q_since = "&since_id=#{since_id}" if since_id

      url = "#{USER_TIMELINE_JSON_URL}?user_id=#{user_id}#{q_since}"
      uri = URI.parse(url)

      Logger.info("Connecting to #{url}")

      http_response = Net::HTTP.get_response(uri)

      #Logger.debug("Response: #{http_response.code} #{http_response.msg}\n#{http_response.body}")

      unless http_response.kind_of?(Net::HTTPSuccess)
        Logger.error("Response: #{http_response.code} #{http_response.msg}\n#{http_response.body}")
        return []
      end

      json_result = JSON.parse(http_response.body)

      tweet_array = json_result.collect{|obj| Tweet.from_status_json(obj)}
      max_id_obj = json_result.max{|a,b| a['id'] <=> b['id']}

      # add some more info to the result
      class << tweet_array
        attr_accessor :max_id
      end

      tweet_array.max_id = max_id_obj ? max_id_obj['id'] : since_id

      tweet_array
    end
  end
end