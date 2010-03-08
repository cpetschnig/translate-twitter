class Tweet

  attr_accessor :text
  attr_reader :translation, :id, :from_user

  def self.from_search_json(hash)
    #{"profile_image_url"=>"http://a1.twimg.com/profile_images/539825688/NAK_0146_normal.jpg",
    #"created_at"=>"Thu, 25 Feb 2010 02:27:24 +0000",
    #"from_user"=>"yukihiro_matz",
    #"to_user_id"=>nil,
    #"text"=>"取材終わり。 (@ ネットワーク応用通信研究所) http://4sq.com/cyEStd",
    #"id"=>9605790199,
    #"from_user_id"=>4363389,
    #"geo"=>nil,
    #"iso_language_code"=>"ja",
    #"source"=>"&lt;a href=&quot;http://foursquare.com&quot; rel=&quot;nofollow&quot;&gt;foursquare&lt;/a&gt;"}
    self.new(hash)
  end

  def self.from_status_json(hash)
    #"in_reply_to_screen_name":null,
    #"in_reply_to_user_id":null,
    #"in_reply_to_status_id":null,
    #"contributors":null,
    #"source":"web",
    #"favorited":false,
    #"user":{...},
    #"geo":null,
    #"id":10083696481,
    #"created_at":"Sat Mar 06 18:11:25 +0000 2010",
    #"truncated":false,
    #"text":"JavaScript\u3068\u304b\u3067\u3001\u30e1\u30bd\u30c3\u30c9\u547c\u3073\u51fa\u3057\u306e\u3064\u3082\u308a\u3067\u62ec\u5f27\u3092\u5fd8\u308c\u3066\u300c\u3042\u301c\u3063\u300d\u3068\u306a\u308b\u79c1\u306f\u3001\u3069\u3093\u3060\u3051Ruby\u8133\u3002"
    hash['from_user'] = hash['user']['screen_name'] if hash.key?('user')
    self.new(hash)
  end

  def initialize(hash)
    @created_at = hash['created_at']
    @from_user = hash['from_user']
    #@to_user_id = hash['to_user_id']
    @text = hash['text']
    @id = hash['id']
  end

  def translation=(value)
    @translation = value
    repair_translation!
  end
  
  def to_s
    "Original:    #{@text}\n" +
    "Translation: #{@translation}"
  end

  def url
    "http://twitter.com/#{@from_user}/status/#{@id}"
  end

  private
  def repair_translation!
    # check for twitter account translations: '@username' might have become '@ username'
    @text.scan(/@[a-zA-Z0-9_]+/) do |match|
      # the translator likes to break twitter usernames
      # "@nari3" became "@ nari 3"
      broken_username = match[1..-1].gsub(/(\d+)/, ' \1 ').strip
      @translation.gsub!(%r{@ #{broken_username}}, match)
    end
  end

end

