source 'https://rubygems.org/'

gem 'rails', '~> 3.2.22'
gem 'mysql2', '~> 0.3.10'
gem 'twitter', :require => false
gem 'activeadmin'
gem 'omniauth-twitter'
gem 'bing_translator'
gem 'constantrecord'
gem 'blueprint-rails'
gem 'htmlentities'
gem 'whenever', :require => false
gem 'devise'
gem 'test-unit'
gem 'rollbar', '~> 2.4.0'

group :development, :test do
  gem 'looksee'
  gem 'pry'
  gem 'cane'
  gem 'fudge'
  gem 'sqlite3'
  gem 'webmock'

  # Deploying with Capistrano
  gem 'capistrano', require: false
  gem 'capistrano-rails', require: false

  gem 'capistrano-rbenv', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-unicorn', require: false
end

group :production do
  # Use unicorn as the app server
  gem 'unicorn'
end

group :test do
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'shoulda-matchers'
  gem 'simplecov', :require => false
  gem 'coveralls', :require => false
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end
