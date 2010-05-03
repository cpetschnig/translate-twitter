module ApplicationHelper
  def parse_tweet(text)
    text.gsub(/(https?:\/\/[^ ]+)/, '<a href="\1">\1</a>').
      gsub(/@([a-zA-Z0-9_]+)/, '@<a href="http://twitter.com/\1">\1</a>').html_safe
  end
end
