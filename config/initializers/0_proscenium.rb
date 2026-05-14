# frozen_string_literal: true

Rails.configuration.proscenium.precompile = Set[
  './app/components/**/*.js',
  './app/views/**/*.js',
  './app/views/**/*.css',
  './**/*.module.css'
]

Rails.configuration.proscenium.ensure_loaded = :log
Rails.configuration.proscenium.logging = ENV.key?('PROSCENIUM_LOGGING')
Rails.configuration.proscenium.debug = ENV.key?('PROSCENIUM_DEBUG')
