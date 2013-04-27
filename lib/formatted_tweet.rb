# Contains common Tweet formatting functionality
module FormattedTweet

  # Wraps URLs with <a> tags; links Twitter usernames to their Twitter profile page
  def formatted
    text.gsub(/(https?:\/\/[^ ]+)/, '<a href="\1">\1</a>').
      gsub(/@([a-z0-9_]+)/i, '<a href="http://twitter.com/\1">@\1</a>').html_safe
  end
end
