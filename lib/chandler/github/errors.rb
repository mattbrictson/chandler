module Chandler
  class GitHub
    Error = Class.new(StandardError)

    class InvalidRepository < Error
      def initialize(repository)
        @repository = repository
      end

      def message
        "Failed to find GitHub repository: #{@repository}.\n"\
        "Verify you have permission to access it. Use the --github option to "\
        "specify a different repository."
      end
    end

    class NetrcAuthenticationFailure < Error
      def message
        "GitHub authentication failed.\n"\
        "Check that ~/.netrc is properly configured.\n"\
        "For instructions, see: "\
        "https://github.com/octokit/octokit.rb#using-a-netrc-file"
      end
    end

    class TokenAuthenticationFailure < Error
      def message
        "GitHub authentication failed.\n"\
        "Check that the CHANDLER_GITHUB_API_TOKEN environment variable "\
        "is correct."
      end
    end
  end
end
