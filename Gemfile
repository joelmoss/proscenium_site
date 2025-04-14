# frozen_string_literal: true

source 'https://rubygems.org'

gem 'bootsnap', require: false
gem 'gems'
gem 'phlex-rails', '~> 1'
gem 'proscenium'
gem 'puma', '>= 5.0'
gem 'rails', '~> 8.0.2'
gem 'sqlite3'
gem 'tzinfo-data', platforms: %i[windows jruby]

gem 'aws-sdk-s3', require: false
gem 'sentry-rails'

group :development, :test do
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

group :development do
  gem 'web-console'
end
