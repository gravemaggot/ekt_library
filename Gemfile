source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'
gem 'active_model_serializers'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'fast_jsonapi'
gem 'image_processing'
gem 'jbuilder', '~> 2.5'
gem 'mini_magick', '~> 4.11'
gem 'mini_racer'
gem 'oj'
gem 'pg'
gem 'pg_search'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.3'
gem 'sass-rails', '~> 5.0'
gem 'slim-rails'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker', '~> 4.x'
gem 'kaminari'

# optimization tools
gem 'activerecord-import', '~> 1.2'
gem 'pghero', '~> 2.8'
gem 'pg_query', '~> 2.1'
gem 'rack-mini-profiler', '~> 2.3'
gem 'newrelic_rpm'

# for deploy
gem 'ed25519', '>= 1.2', '< 2.0'
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'parallel_tests'
  gem 'spring-commands-parallel-tests'
  gem 'rspec-rails', '~> 3.8'
  gem 'ruby-prof', '>= 0.16.0', require: false
  gem 'rubocop', require: false
  gem 'stackprof'
end

group :development do
  gem 'better_errors'
  gem 'bullet', '~> 6.1'
  gem 'capistrano', '~> 3.12.1', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-yarn'
  gem 'capistrano-npm'
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'tty'
  gem 'tty-command'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'chromedriver-helper'
  # gem 'database_cleaner'
  gem 'fuubar'
  gem 'influxer', '~> 1.2'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'test-prof', '~> 1.0'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
