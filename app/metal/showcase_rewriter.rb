# Allow the metal piece to run in isolation
require File.expand_path('../../../config/environment',  __FILE__) unless defined?(Rails)

class ShowcaseRewriter
  def self.call(env)
    path_info = env['PATH_INFO'][1..-1]

    # use plain SQL for better speed
    sql = %{SELECT "twitter_accounts"."username" FROM "twitter_accounts"}
    usernames = ActiveRecord::Base.connection.select_all(sql)

    #if TwitterAccount.all(:select => 'username').map{|ta| ta.username}.include? env['PATH_INFO']
    if usernames.map{|ta| ta['username']}.include?(path_info)
      env['PATH_INFO'] = "/showcase/#{path_info}"
      env['REQUEST_URI'].sub!(path_info, "showcase/#{path_info}")
    end

    [404, {"Content-Type" => "text/html", "X-Cascade" => "pass"}, ["Not Found"]]
  end
end
