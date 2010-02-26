class Tweet

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

  attr_accessor :text
  attr_reader :translation, :id, :from_user
  
  def self.from_json(hash)
  #p hash
    self.new(hash)
  end

  def initialize(hash)
    @created_at = hash['created_at']
    @from_user = hash['from_user']
    @to_user_id = hash['to_user_id']
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
    # TODO: needs improvement!
    # matz twittered "@nari3", which got translated to "@ nari 3"
    # need to repair those cases

    # check for twitter account translations: '@username' might have become '@ username'
    @text.scan(/@[a-zA-Z0-9_]+/) do |match|
      @translation.gsub!(%r{#{match[0,1]} #{match[1..-1]}}, match)
    end
  end

end

