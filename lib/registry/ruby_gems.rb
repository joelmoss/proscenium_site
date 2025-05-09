# frozen_string_literal: true

require 'rubygems/package'
require 'rubygems/remote_fetcher'

module Registry
  class RubyGems
    def self.path_for(name, version)
      Pathname new(name, version).path
    end

    def initialize(name, version)
      @name = name
      @version = version
    end

    def path
      dependency = Gem::Dependency.new @name, @version
      path = get_path dependency

      raise "Gem '#{@name}' not installed nor fetchable." unless path

      basename = File.basename path, '.gem'
      target_dir = File.expand_path basename, Rails.root.join('tmp/unpacked_gems')

      Gem::Package.new(path).extract_files target_dir

      target_dir
    end

    # Find cached filename in Gem.path. Returns nil if the file cannot be found.
    def find_in_cache(filename)
      Gem.path.each do |path|
        this_path = File.join(path, 'cache', filename)
        return this_path if File.exist? this_path
      end

      nil
    end

    # Return the full path to the cached gem file matching the given name and version requirement.
    # Returns 'nil' if no match.
    def get_path(dependency)
      return dependency.name if /\.gem$/i.match?(dependency.name)

      specs = dependency.matching_specs
      selected = specs.max_by(&:version)

      return Gem::RemoteFetcher.fetcher.download_to_cache(dependency) unless selected
      return unless /^#{selected.name}$/i.match?(dependency.name)

      # We expect to find (basename).gem in the 'cache' directory. Furthermore,
      # the name match must be exact (ignoring case).
      path = find_in_cache File.basename selected.cache_file

      return Gem::RemoteFetcher.fetcher.download_to_cache(dependency) unless path

      path
    end
  end
end
