# frozen_string_literal: true

require 'aws-sdk-s3'

class Registry::DeleteTarball
  def initialize(package)
    @package = package
  end

  def call
    Rails.logger.info do
      "[Registry] DeleteTarball name=#{@package.name} version=#{@package.version}"
    end

    return if Rails.env.test?

    r2.delete_object(bucket: bucket_name, key: filepath)
  end

  private

    def filepath = "#{@package.name}/#{@package.name}-#{@package.version}.tgz"

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
