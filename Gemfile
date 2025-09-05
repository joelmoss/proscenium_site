# frozen_string_literal: true

source 'https://rubygems.org'

# ruby file: './.ruby-version'

gem 'aws-sdk-s3', require: false
gem 'bootsnap', require: false
gem 'gems'
gem 'htmlbeautifier'
gem 'kamal'
gem 'literal'
gem 'markly'
gem 'phlexible'
gem 'phlex-rails', '~> 1'
gem 'proscenium' # , path: '../proscenium'
gem 'proscenium-ui', github: 'joelmoss/proscenium-ui'
gem 'puma', '>= 5.0'
gem 'rails', '~> 8.0.2'
gem 'rouge'
gem 'sqlite3'
gem 'thruster'
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'amazing_print'
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'rubocop-minitest', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

group :test do
  gem 'maxitest'
  gem 'minitest-focus'
  gem 'minitest-spec-rails'
  gem 'webmock'
end

group :development do
  gem 'parity'
  gem 'web-console'
end

group :production do
  # gem 'cloudflare-rails'
  gem 'sentry-rails'
  gem 'sentry-ruby'
end
