require "chandler/configuration"
require "chandler/version"
require "optparse"

module Chandler
  class CLI
    class Parser
      attr_reader :args, :config

      def initialize(args, config=Chandler::Configuration.new)
        @args = args
        @config = config
        parse_options
      end

      def usage
        option_parser.to_s
      end

      private

      def parse_options
        unprocessed = []
        until args.empty?
          option_parser.order!(args)
          unprocessed << args.shift
        end
        @args = unprocessed.compact
      end

      def option_parser # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        OptionParser.new do |opts|
          opts.banner = "Usage: chandler push [tag] [options]"
          opts.separator("")
          opts.separator(summary)
          opts.separator("")

          opts.on("--git=[PATH]", "Path to .git directory") do |p|
            config.git_path = p
          end

          opts.on("--github=[URL]",
                  "GitHub repository URL or owner/repo") do |u|
            config.github_repository = u
          end

          opts.on("--changelog=[PATH]",
                  "Path to CHANGELOG Markdown file") do |p|
            config.changelog_path = p
          end

          opts.on("--dry-run",
                  "Simulate, but don’t actually push to GitHub") do |d|
            config.dry_run = d
          end

          opts.on("--debug", "Enable debug output") do |d|
            config.logger.verbose = d
          end

          opts.on("-h", "--help", "Show this help message") do
            puts(opts)
            exit
          end

          opts.on("-v", "--version", "Print the chandler version number") do
            puts("chandler version #{Chandler::VERSION}")
            exit
          end
        end
      end

      def summary
        <<-SUMMARY
chandler scans your git repository for version tags (e.g. `v1.0.2`), parses out
the corresponding release notes for those tags from your CHANGELOG, and uploads
those notes to the GitHub releases area via the GitHub API.

chandler will use reasonable defaults and inferences to configure itself.
If chandler doesn’t work for you out of the box, override the configuration
using these options.
SUMMARY
      end
    end
  end
end
