module Twitter
  class User

    USER_SHOW_JSON_URL = 'http://api.twitter.com/1/users/show/{{USERNAME}}.json'

    attr_reader :screen_name, :twitter_id, :name, :location, :url, :image_url,
      :followers_count

    def initialize(params)
      @screen_name = params['screen_name']
      @twitter_id = params['id']
      @name = params['name']
      @location = params['location']
      @url = params['url']
      @image_url = params['profile_image_url']
      @followers_count = params['followers_count']
    end

    def self.fetch(username)

      uri = URI.parse(USER_SHOW_JSON_URL.sub('{{USERNAME}}', username))

      http_response = Net::HTTP.get_response(uri)

      #Rails.logger.info("=> #{http_response.code} #{http_response.msg}")

      unless http_response.kind_of?(Net::HTTPSuccess)
        Rails.logger.error("Response: #{http_response.code} #{http_response.msg}\n#{http_response.body}")
        return nil
      end

      json_result = JSON.parse(http_response.body)

      User.new(json_result)
    end

    def url(format = nil)
      return '' if @url.nil? || @url.empty?

      return @url if format.nil?

      if format == :short
        return @url if @url.length < 40
        return "#{@url[0,38]}..."
      end
      
      Rails.logger.warn "WARNING: unknown `format` #{format} in Twitter::User#url"
      @url
    end

  end
end
