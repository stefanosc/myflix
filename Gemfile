source 'https://rubygems.org'
ruby '2.2.0'

gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'coffee-rails'
gem 'rails', '~> 4.0.4'
gem 'haml-rails'
gem 'sass-rails', '~> 4.0.2'
gem 'uglifier'
gem 'jquery-rails'
gem 'bcrypt-ruby', '~> 3.1.2'
gem "figaro"
gem 'roadie'
gem 'sidekiq'
gem 'foreman'
gem 'unicorn'
gem 'carrierwave'
gem 'fog'
gem 'draper'
gem 'mini_magick'
gem 'stripe'
gem 'stripe_event'

group :development do
  gem 'sqlite3'
  gem 'thin'
  # gem "better_errors"
  gem "binding_of_caller"
  gem 'letter_opener'
  gem 'paratrooper'
end

group :production, :staging do
  gem 'pg'
  gem 'rails_12factor'
  gem "sentry-raven"
  gem 'sinatra', require: false
  gem 'slim'
end

group :development, :test do
  gem 'rspec-rails'
  gem "faker"
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'knapsack'
end

group :test do
  gem "capybara"
  gem 'capybara-email'
  gem "database_cleaner"
  gem "launchy"
  gem 'shoulda-matchers'
  gem "selenium-webdriver"
  gem 'poltergeist', require: false
  gem "fivemat", '1.2.1'
  gem 'fabrication'
  gem 'vcr'
  gem 'webmock'
end
