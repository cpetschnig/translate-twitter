source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '3.2.12'
gem 'mysql2'
gem 'activeadmin'
gem 'constantrecord'
gem 'blueprint-rails'

group :development, :test do
  gem 'looksee'
  gem 'pry'
end

group :development do
  # Deploy with Capistrano
  # gem 'capistrano'
end

group :test do
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'shoulda-matchers'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end
