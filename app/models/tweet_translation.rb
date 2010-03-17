class TweetTranslation < ActiveRecord::Base
  belongs_to :tweet

  def before_save
    repair_translation!
  end

  private
  def repair_translation!
    # check for twitter account translations: '@username' might have become '@ username'
    self.tweet.text.scan(/@[a-zA-Z0-9_]+/) do |match|
      # the translator likes to break twitter usernames
      # "@nari3" became "@ nari 3"
      broken_username = match[1..-1].gsub(/(\d+)/, ' \1 ').strip
      self.text.gsub!(%r{@ #{broken_username}}, match)
    end
  end
end
