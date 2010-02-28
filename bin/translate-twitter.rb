#!/usr/bin/env ruby

require 'rubygems'
require 'net/http'
require 'open-uri'
require 'uri'
require 'json'
require 'nokogiri'

require File.join(File.dirname(__FILE__), '../lib/tweet')
require File.join(File.dirname(__FILE__), '../config')



# R E A D
# =======

# read latest tweet id
since_id = File.exist?(TIMESTAMP_FILENAME) && File.read(TIMESTAMP_FILENAME)
q_since = "&since_id=#{since_id}" if since_id


t_search_url = "http://search.twitter.com/search.json?q=from%3A#{TWITTER_MATZ_USERNAME}#{q_since}"
t_search_uri = URI.parse(t_search_url)

#json_result = JSON.parse(File.read("read_from_local_file"))
http_response = Net::HTTP.get(t_search_uri)
json_result = JSON.parse(http_response)
#p json_result
# structure of twitter response:

f = File.open(File.join(File.dirname(__FILE__), '..', 'log', "#{Time.new.strftime('%Y-%m-%d_%H-%M-%S')}_search.json"), 'a')
f.write("// #{Time.new.strftime('%Y-%m-%d %H:%M:%S')}\n")
f.write("// #{t_search_url}\n")
f.write(http_response)
f.close

#results: ...
#max_id: 9619561014
#since_id: 0
#refresh_url: ?since_id=9619561014&q=from%3Ayukihiro_matz
#next_page: ?page=2&max_id=9619561014&q=from%3Ayukihiro_matz
#results_per_page: 15
#page: 1
#completed_in: 0.06933
#query: from%3Ayukihiro_matz

tweets = json_result['results'].collect{|obj| Tweet.from_json(obj)}


# store latest tweet id
f = File.open(TIMESTAMP_FILENAME, 'w')
f.write(json_result['max_id'])
f.close


exit if tweets.empty?
#if tweets.empty?
##  `touch #{LOG_FILE}`   # leave a little trace
#  exit
#end



# T R A N S L A T E
# =================

tanslate_uri = URI.parse(MS_TRANSLATE_SOAP_URL)

t_req = Net::HTTP::Post.new(tanslate_uri.path)
t_req.content_type = 'text/xml; charset=utf-8'
t_req['SOAPAction'] = MS_TRANSLATE_SOAP_ACTION


tweets.each do |tweet|

  t_req.body = MS_TRANSLATE_SOAP_BODY.sub('{{TEXT}}', tweet.text)

  t_res = Net::HTTP.new(tanslate_uri.host, tanslate_uri.port).start do |http|
    http.request(t_req)
  end

  doc = Nokogiri::XML(t_res.body)

  tweet.translation = doc.xpath('.//mst:TranslateResult/text()', 'mst' => MS_TRANSLATE_SOAP_NS).to_s

#  puts tweet.url
#  puts tweet.text
#  puts tweet.translation

  `echo "\`date\`: translated #{tweet.url}" >> #{LOG_FILE}`

end



# P U B L I S H
# =============

tweets.reverse_each do |tweet|

  api_url = 'http://twitter.com/statuses/update.json'
  url = URI.parse(api_url)
  req = Net::HTTP::Post.new(url.path)
  req.basic_auth(TWITTER_TARGET_USER, TWITTER_TARGET_PASSWD)
  req.set_form_data({ 'status'=> tweet.translation[0,140] }, ';')
  res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
  #p res

  `echo "\`date\`: tweeted translation of #{tweet.url} => #{res.code}" >> #{LOG_FILE}`

end

