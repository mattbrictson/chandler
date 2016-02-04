require "chandler/cli/parser"
require "chandler/commands/push"
require "chandler/logging"
require "forwardable"

module Chandler
  # Handles constructing and invoking the appropriate chandler command
  # based on command line arguments and options provided by the CLI::Parser.
  # Essentially this is the "router" for the command-line app.
  #
  class CLI
    include Logging
    extend Forwardable
    def_delegator :@parser, :args
    def_delegator :@parser, :config

    def initialize(parser: Chandler::CLI::Parser.new(ARGV))
      @parser = parser
    end

    def run
      command.call
    end

    private

    def command # rubocop:disable Metrics/MethodLength
      case (command = args.shift)
      when "push"
        push
      when nil
        error("Please specify a command")
        info(@parser.usage)
        exit(1)
      else
        error("Unrecognized command: #{command}")
        info(@parser.usage)
        exit(1)
      end
    end

    def push
      Chandler::Commands::Push.new(
        :tags => args.empty? ? config.git.tagged_versions : args,
        :config => config
      )
    end
  end
end
