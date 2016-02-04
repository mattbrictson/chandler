require "chandler/refinements/version_format"
require "open3"

module Chandler
  # Uses the shell to execute git commands against a given .git directory.
  class Git
    using Chandler::Refinements::VersionFormat

    Error = Class.new(StandardError)
    attr_reader :path, :tag_mapper

    # Initializes the Git object with the path to the `.git` directory of the
    # desired git repository.
    #
    # Chandler::Git.new(:path => "/path/to/my/project/.git")
    #
    def initialize(path:, tag_mapper:)
      @path = path
      @tag_mapper = tag_mapper
    end

    # Uses `git tag -l` to obtain the list of tags, then returns the subset of
    # those tags that appear to be version numbers.
    #
    # tagged_versions # => ["v0.0.1", "v0.2.0", "v0.2.1", "v0.3.0"]
    #
    # rubocop:disable Style/SymbolProc
    def tagged_versions
      tags = git("tag", "-l").lines.map(&:strip).map(&tag_mapper).compact
      tagged_versions = tags.select { |v| v.version? }
      tagged_versions.sort_by { |t| Gem::Version.new(t.version_number) }
    end
    # rubocop:enable Style/SymbolProc

    # Uses `git remote -v` to list the remotes and returns the URL of the
    # first one labeled "origin".
    #
    # origin_remote # => "git@github.com:mattbrictson/chandler.git"
    #
    def origin_remote
      origin = git("remote", "-v").lines.grep(/^origin\s/).first
      origin && origin.split[1]
    end

    private

    def git(*args)
      capture("git", "--git-dir", path, *args)
    end

    def capture(*args)
      out, err, status = Open3.capture3(*args)
      return out if status.success?

      message = "Failed to execute: #{args.join(' ')}"
      message << "\n#{err}" unless err.nil?
      fail Error, message
    end
  end
end
