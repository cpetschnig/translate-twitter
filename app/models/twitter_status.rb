module Twitter
  class Status

    USER_TIMELINE_JSON_URL = 'http://api.twitter.com/1/statuses/user_timeline.json'
    TWEET_JSON_URL = 'http://twitter.com/statuses/update.json'

    def self.from(user_id, options = {})

      since_id = options.delete(:since_id)
      q_since = "&since_id=#{since_id}" if since_id

      url = "#{USER_TIMELINE_JSON_URL}?user_id=#{user_id}#{q_since}"
      uri = URI.parse(url)

      Rails.logger.info("Connecting to #{url}")

      http_response = Net::HTTP.get_response(uri)

      Rails.logger.debug("Response: #{http_response.code} #{http_response.msg}\n#{http_response.body}")

      unless http_response.kind_of?(Net::HTTPSuccess)
        Rails.logger.error("Response: #{http_response.code} #{http_response.msg}\n#{http_response.body}")
        return []
      end

      #Tweet.from_status_json(http_response.body)

      json_result = JSON.parse(http_response.body)

      tweet_array = json_result.collect{|obj| Tweet.from_status_json(obj)}
      max_id_obj = json_result.max{|a,b| a['id'] <=> b['id']}

#      # add some more info to the result
#      class << tweet_array
#        attr_accessor :max_id
#      end
#
#      tweet_array.max_id = max_id_obj ? max_id_obj['id'] : since_id
#
#      tweet_array

      [ tweet_array, max_id_obj ? max_id_obj['id'] : since_id ]
    end

    def self.tweet(username, password, text)

      url = URI.parse(TWEET_JSON_URL)
      req = Net::HTTP::Post.new(url.path)
      req.basic_auth(username, password)
      req.set_form_data({ 'status'=> text }, ';')
      Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
  #p res

  #`echo "\`date\`: tweeted translation of #{tweet.url} => #{res.code}" >> #{LOG_FILE}`
    end

  end
end