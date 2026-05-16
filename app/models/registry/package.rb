# frozen_string_literal: true

# 1. Fetch the gem metadata from RubyGems API.
# 2. Extract any package.json from the gem, and populate the response with it.
# 3. Create a tarball containing the fetched package.json. This will be downloaded by the npm
#    client, and unpacked into node_modules. Proscenium ignores the contents, as it will fetch them
#    directly from location of the installed gem.
# 4. Return a valid npm response listing package details, tarball location, and its dependencies.
#
# See https://wiki.commonjs.org/wiki/Packages/Registry
class Registry::Package < ApplicationRecord
  class << self
    def finreate!(name, version = nil)
      begin
        name => ^(/\A[\w_-]+\z/)
      rescue NoMatchingPatternError => e
        raise ActiveRecord::RecordNotFound.new("Couldn't find Gem '#{name}'"), cause: e
      end

      if version.present?
        if !Gem::Version.correct?(version)
          raise ActiveRecord::RecordNotFound,
                "Couldn't find Gem '#{name}' with version '#{version}'"
        end

        existing = find_by(name:, version:)

        begin
          spec = gemspec(name, version)
        rescue ActiveRecord::RecordNotFound
          # Version was yanked from RubyGems; drop the cached row + tarball.
          existing&.destroy!
          raise
        end

        existing || create_or_find_by!(name:, version: spec['version'])
      else
        # Version not given, so get the latest version.
        find_or_create_by!(name:, version: gemspec(name)['version'])
      end
    end

    private

      def gemspec(name, version = nil)
        Rails.logger.info do
          "[Package] fetching gemspec name=#{name.inspect} version=#{version.inspect}"
        end

        version.present? ? Gems::V2.info(name, version) : Gems.info(name)
      rescue Gems::NotFound => e
        msg = "Couldn't find Gem '#{name}'"
        msg << " with version '#{version}'" if version.present?
        raise ActiveRecord::RecordNotFound.new(msg), cause: e
      end
  end

  before_create :fetch_package_json, :create_tarball
  after_destroy_commit :delete_tarball

  def as_json(tarball_host: nil)
    {
      name: full_name,
      'dist-tags': {
        latest: version
      },
      versions: {
        version => {
          name: full_name,
          version:,
          dependencies: package_json['dependencies'] || {},
          dist: {
            shasum:,
            integrity:,
            tarball: tarball_url(tarball_host)
          }
        }
      }
    }
  end

  def tarball_url(host)
    "#{host}/tarballs/#{name}/#{version}.tgz"
  end

  def full_name = @full_name ||= "@rubygems/#{name}"
  def package_json = @package_json ||= JSON.parse(package_data)

  private

    def fetch_package_json
      path = Registry::RubyGems.path_for(name, version).join('package.json')

      Rails.logger.info do
        "[Registry] fetch_package_json name=#{name} version=#{version} exists=#{path.exist?}"
      end

      self.package_data = if path.exist?
                            path.read
                          else
                            { name: full_name, version:, dependencies: {} }.to_json
                          end
    end

    def create_tarball
      Rails.logger.info "[Registry] create_tarball name=#{name} version=#{version}"

      ball = Registry::CreateTarball.new(self)
      self.tarball = ball.tarball
      self.integrity = ball.integrity
      self.shasum = ball.shasum
    end

    def delete_tarball
      Registry::DeleteTarball.new(self).call
    end
end
