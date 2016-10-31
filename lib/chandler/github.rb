require "chandler/github/client"
require "chandler/github/errors"
require "chandler/github/remote"

module Chandler
  # A facade for performing GitHub API operations on a given GitHub repository
  # (specified as a git URL or as `owner/repo` format). Requires either that
  # "~/.netrc" is properly configured with GitHub credentials or an auth token
  # is available in the host environment at "CHANDLER_GITHUB_API_TOKEN""
  #
  class GitHub
    attr_reader :repository, :config

    def initialize(repository:, config:)
      @repository = repository
      @remote = Remote.parse(repository)
      @config = config
    end

    def create_or_update_release(tag:, title:, description:)
      return if config.dry_run?

      release = existing_release(tag)
      return update_release(release, title, description) if release

      create_release(tag, title, description)
    rescue Octokit::NotFound
      raise InvalidRepository, repository
    end

    private

    attr_reader :remote

    def existing_release(tag)
      release = client.release_for_tag(remote.repository, tag)
      release.id.nil? ? nil : release
    rescue Octokit::NotFound
      nil
    end

    def update_release(release, title, desc)
      return if release_unchanged?(release, title, desc)
      client.update_release(release.url, :name => title, :body => desc)
    end

    def release_unchanged?(release, title, desc)
      release.name == title && release.body.to_s.strip == desc.strip
    end

    def create_release(tag, title, desc)
      client.create_release(
        remote.repository, tag, :name => title, :body => desc
      )
    end

    def client
      @client ||= Client.new(:host => remote.host).tap(&:login!)
    end
  end
end
