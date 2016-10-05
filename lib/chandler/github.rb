require "octokit"

module Chandler
  # A facade for performing GitHub API operations on a given GitHub repository
  # (specified as a git URL or as `owner/repo` format). Requires either that
  # "~/.netrc" is properly configured with GitHub credentials or an auth token
  # is available in the host environment at "CHANDLER_GITHUB_API_TOKEN""
  #
  class GitHub
    MissingCredentials = Class.new(StandardError)

    attr_reader :repository, :config

    def initialize(repository:, config:)
      @repository = parse_repository(repository)
      @config = config
    end

    def create_or_update_release(tag:, title:, description:)
      return if config.dry_run?

      release = existing_release(tag)
      return update_release(release, title, description) if release

      create_release(tag, title, description)
    end

    private

    def parse_repository(repo)
      repo[%r{(git@github.com:|://github.com/)(.*)\.git}, 2] || repo
    end

    def existing_release(tag)
      release = client.release_for_tag(repository, tag)
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
      client.create_release(repository, tag, :name => title, :body => desc)
    end

    def client
      @client ||= begin
        octokit = config.octokit
        octokit.login ? octokit : fail_missing_credentials
      end
    end

    def fail_missing_credentials
      message = "Couldn’t load GitHub credentials from ~/.netrc.\n"
      message << "For .netrc instructions, see: "
      message << "https://github.com/octokit/octokit.rb#using-a-netrc-file"
      raise MissingCredentials, message
    end
  end
end
