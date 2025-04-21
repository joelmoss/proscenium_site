# frozen_string_literal: true

require 'aws-sdk-s3'

class Registry::CreateTarball
  def initialize(package)
    @package = package

    create!
    upload! unless Rails.env.test?
  end

  def shasum = Digest::SHA1.file(tmp_filepath).hexdigest
  def integrity = "sha512-#{Digest::SHA512.file(tmp_filepath).base64digest}"
  def tarball = "#{bucket_url}/#{filepath}"

  private

    def filepath
      @filepath ||= "#{@package.name}/#{@package.name}-#{@package.version}.tgz"
    end

    def tmp_filepath
      @tmp_filepath ||= Rails.root.join("tmp/registry_tarballs/#{filepath}")
    end

    def create!
      FileUtils.mkdir_p(File.dirname(tmp_filepath))

      File.open(tmp_filepath, 'wb') do |file|
        Zlib::GzipWriter.wrap(file) do |gz|
          Gem::Package::TarWriter.new(gz) do |tar|
            tar.add_file_simple('package/package.json', 0o444, @package.package_data.length) do |io|
              io.write @package.package_data
            end
          end
        end
      end
    end

    def upload!
      r2.put_object(
        bucket: bucket_name,
        key: filepath,
        body: File.open(tmp_filepath),
        content_type: 'application/gzip'
      )
    end

    def r2
      @r2 ||= Aws::S3::Client.new(
        access_key_id: access_key_id,
        secret_access_key: secret_access_key,
        endpoint: "https://#{account_id}.r2.cloudflarestorage.com",
        region: 'auto'
      )
    end

    def access_key_id = Rails.application.credentials.cloudflare_r2.access_key_id!
    def secret_access_key = Rails.application.credentials.cloudflare_r2.secret_access_key!
    def account_id = Rails.application.credentials.cloudflare_r2.account_id!
    def bucket_name = Rails.application.credentials.cloudflare_r2.bucket_name!

    def bucket_url
      return 'bucket.url' if Rails.env.test?

      Rails.application.credentials.cloudflare_r2.public_bucket_url!
    end
end
