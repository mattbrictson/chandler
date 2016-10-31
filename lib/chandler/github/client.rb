require "chandler/github/errors"
require "delegate"
require "octokit"
require "uri"

module Chandler
  class GitHub
    # A thin wrapper around Octokit::Client that adds support for automatic
    # GitHub Enterprise, .netrc, and ENV token-based authentication.
    #
    class Client < SimpleDelegator
      def initialize(host: "github.com",
                     environment: ENV,
                     octokit_client: Octokit::Client)
        options = {}
        options.merge!(detect_auth_option(environment))
        options.merge!(detect_enterprise_endpoint(host))
        super(octokit_client.new(options))
      end

      def login!
        return if login
        raise netrc ? NetrcAuthenticationFailure : TokenAuthenticationFailure
      end

      private

      def detect_auth_option(env)
        if (token = env["CHANDLER_GITHUB_API_TOKEN"])
          { :access_token => token }
        else
          { :netrc => true }
        end
      end

      def detect_enterprise_endpoint(host)
        return {} if host.downcase == "github.com"
        { :api_endpoint => "https://#{host}/api/v3/" }
      end
    end
  end
end
