# frozen_string_literal: true

class Registry::Package < ApplicationRecord
  class << self
    def finreate!(name, version = nil)
      begin
        name => ^(/\A[\w_-]+\z/)
      rescue NoMatchingPatternError => e
        raise ActiveRecord::RecordNotFound.new("Couldn't find Gem '#{name}'"), cause: e
      end

      if version.present?
        unless Gem::Version.correct?(version)
          raise ActiveRecord::RecordNotFound,
                "Couldn't find Gem '#{name}' with version '#{version}'"
        end

        find_by(name:, version:) ||
          create_or_find_by!(name:, version: gemspec(name, version)['version'])
      else
        # Version not given, so get the latest version.
        find_or_create_by!(name:, version: gemspec(name)['version'])
      end
    end

    private

    def gemspec(name, version = nil)
      version.present? ? Gems::V2.info(name, version) : Gems.info(name)
    rescue Gems::NotFound => e
      msg = "Couldn't find Gem '#{name}'"
      msg << " with version '#{version}'" if version.present?
      raise ActiveRecord::RecordNotFound.new(msg), cause: e
    end
  end

  before_create :fetch_package_json, :create_tarball

  def as_json
    {
      name:,
      'dist-tags': {
        latest: version
      },
      versions: {
        version => {
          name:,
          version:,
          dependencies: package_json['dependencies'] || {},
          dist: {
            shasum:,
            integrity:,
            tarball:
          }
        }
      }
    }
  end

  def package_json
    @package_json ||= JSON.parse(package_data)
  end

  private

  def fetch_package_json
    path = Registry::RubyGems.path_for(name, version).join('package.json')
    self.package_data = path.exist? ? path.read : { name:, version:, dependencies: {} }.to_json
  end

  def create_tarball
    ball = Registry::CreateTarball.new(self)
    self.tarball = ball.tarball
    self.integrity = ball.integrity
    self.shasum = ball.shasum
  end
end
