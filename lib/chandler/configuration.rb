require "chandler/changelog"
require "chandler/git"
require "chandler/github"
require "chandler/logger"

module Chandler
  class Configuration
    attr_accessor :changelog_path, :git_path, :github_repository, :dry_run,
                  :tag_prefix, :logger

    def initialize
      @changelog_path = "CHANGELOG.md"
      @git_path = ".git"
      @logger = Chandler::Logger.new
      @dry_run = false
    end

    def dry_run?
      dry_run
    end

    def git
      @git ||= Chandler::Git.new(:path => git_path, :tag_mapper => tag_mapper)
    end

    def github
      @github ||=
        Chandler::GitHub.new(:repository => github_repository, :config => self)
    end

    def changelog
      @changelog ||= Chandler::Changelog.new(:path => changelog_path)
    end

    def github_repository
      @github_repository || git.origin_remote
    end

    def tag_mapper
      return :itself if tag_prefix.nil?
      ->(tag) { tag[/^#{Regexp.escape(tag_prefix)}(.*)/, 1] }
    end
  end
end
