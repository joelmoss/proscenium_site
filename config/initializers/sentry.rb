# frozen_string_literal: true

if defined?(Sentry)
  Sentry.init do |config|
    config.dsn = ENV['SENTRY_DSN']
    config.environment = Rails.env
    config.release = ENV.fetch('KAMAL_VERSION', nil)

    config.traces_sample_rate = 1.0
    config.breadcrumbs_logger = %i[active_support_logger http_logger]

    # Add data like request headers and IP for users,
    # see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
    config.send_default_pii = true
  end
end
