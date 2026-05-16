# frozen_string_literal: true

require 'aws-sdk-s3'

class Registry::SignTarball
  EXPIRES_IN = 5.minutes.to_i

  def initialize(package)
    @package = package
  end

  def url
    return "https://signed.test/#{@package.tarball}" if Rails.env.test?

    Aws::S3::Presigner.new(client: r2).presigned_url(
      :get_object,
      bucket: bucket_name,
      key: @package.tarball,
      expires_in: EXPIRES_IN
    )
  end

  private

    def r2
      @r2 ||= Aws::S3::Client.new(
        access_key_id: Rails.application.credentials.cloudflare_r2.access_key_id!,
        secret_access_key: Rails.application.credentials.cloudflare_r2.secret_access_key!,
        endpoint: "https://#{Rails.application.credentials.cloudflare_r2.account_id!}.r2.cloudflarestorage.com",
        region: 'auto'
      )
    end

    def bucket_name = Rails.application.credentials.cloudflare_r2.bucket_name!
end
