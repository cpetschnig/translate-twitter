require 'uri'
require 'json'
require 'net/http'
#require 'tweet'
require File.join(File.dirname(__FILE__), 'tweet')

module Twitter
  class Search

    SEARCH_TWITTER_JSON_URL = 'http://search.twitter.com/search.json'

    def self.from(user_name, options = {})

      since_id = options.delete(:since_id)
      q_since = "&since_id=#{since_id}" if since_id

      t_search_url = "#{SEARCH_TWITTER_JSON_URL}?q=from%3A#{user_name}#{q_since}"
      t_search_uri = URI.parse(t_search_url)

      http_response = Net::HTTP.get(t_search_uri)
      json_result = JSON.parse(http_response)

      tweet_array = json_result['results'].collect{|obj| Tweet.from_search_json(obj)}

      # add some more info to the result
      class << tweet_array
        attr_accessor :max_id
      end

      tweet_array.max_id = json_result['max_id']

      tweet_array
    end
  end
end