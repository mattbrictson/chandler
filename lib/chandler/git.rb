require "chandler/refinements/version_format"
require "chandler/refinements/version"
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
    # version_tags # => ["v0.0.1", "v0.2.0", "v0.2.1", "v0.3.0"]
    #
    def version_tags
      tags = git("tag", "-l").lines.map(&:strip).select do |tag|
        version_part = tag_mapper.call(tag)
        version_part && version_part.version?
      end
      tags.sort_by { |t| Chandler::Refinements::VersionFormat::Version.new(tag_mapper.call(t).version_number) }
    end

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
      raise Error, message
    end
  end
end
