# frozen_string_literal: true

if defined?(Sentry)
  Sentry.init do |config|
    config.dsn = ENV.fetch('SENTRY_DSN', nil)
    config.environment = Rails.env

    config.traces_sample_rate = 1.0
    config.breadcrumbs_logger = %i[active_support_logger http_logger]

    # Collect data like request headers and IP for users (replaces `send_default_pii = true`).
    # See https://develop.sentry.dev/sdk/foundations/client/data-collection/
    config.data_collection = Sentry::DataCollection.new
  end
end
