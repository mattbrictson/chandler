require "uri"

module Chandler
  class GitHub
    # Assuming a git remote points to a public GitHub or a GitHub Enterprise
    # repository, this class parses the remote to obtain the host and repository
    # path. Supports SSH and HTTPS style git remotes.
    #
    # This class also handles parsing values passed into the `--github` command
    # line option, which may be a public GitHub repository name, like
    # "mattbrictson/chandler".
    #
    class Remote
      def self.parse(url)
        if (match = url.match(/@([^:]+):(.+)$/))
          new(match[1], match[2])
        else
          parsed_uri = URI(url)
          host = parsed_uri.host || "github.com"
          path = parsed_uri.path.sub(%r{^/+}, "")
          new(host, path)
        end
      end

      attr_reader :host, :path

      def initialize(host, path)
        @host = host.downcase
        @path = path
      end

      def repository
        path.sub(/\.git$/, "")
      end
    end
  end
end
