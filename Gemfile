# frozen_string_literal: true

source 'https://rubygems.org'

ruby file: '.ruby-version'

gem 'bootsnap', require: false
gem 'gems'
gem 'phlex-rails', '~> 1'
gem 'proscenium'
gem 'puma', '>= 5.0'
gem 'rails', '~> 8.0.2'
gem 'sqlite3'
gem 'tzinfo-data', platforms: %i[windows jruby]

gem 'aws-sdk-s3', require: false

group :development, :test do
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

group :development do
  gem 'parity'
  gem 'web-console'
end

group :production do
  gem 'cloudflare-rails'
  gem 'sentry-rails'
  gem 'sentry-ruby'
end
