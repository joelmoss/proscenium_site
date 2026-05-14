# frozen_string_literal: true

source 'https://rubygems.org'

gem 'aws-sdk-s3', require: false
gem 'bootsnap', require: false
gem 'gems'

gem 'htmlbeautifier'
gem 'literal'
gem 'markly'
gem 'phlex'
gem 'phlexible'
gem 'proscenium-phlex'
gem 'proscenium-ui', github: 'joelmoss/proscenium-ui'
gem 'puma'
gem 'rails'
gem 'rouge'
gem 'sqlite3'
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'amazing_print'
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
end

group :test do
  gem 'maxitest'
  gem 'minitest-focus'
  gem 'minitest-spec-rails'
  gem 'webmock'
end

group :development do
  gem 'rails_caddy_dev'
  gem 'web-console'

  gem 'rubocop-disable_syntax', require: false
  gem 'rubocop-minitest', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

group :production do
  # gem 'cloudflare-rails'
  gem 'sentry-rails'
  gem 'sentry-ruby'
end
