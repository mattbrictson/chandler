require "chandler/refinements/color"

module Chandler
  # Similar to Ruby's standard Logger, but automatically removes ANSI color
  # from the logged messages if stdout and stderr do not support it.
  #
  class Logger
    using Chandler::Refinements::Color
    attr_accessor :stderr, :stdout, :verbose

    def initialize(stderr: $stderr, stdout: $stdout)
      @stderr = stderr
      @stdout = stdout
      @verbose = false
      @color_enabled = nil
    end

    def verbose?
      verbose
    end

    # Logs a message to stderr. Unless otherwise specified, the message will
    # be printed in red.
    def error(message)
      message = message.red unless message.color?
      puts(stderr, message)
    end

    # Logs a message to stdout.
    def info(message)
      puts(stdout, message)
    end

    # Logs a message to stdout, but only if `verbose?` is true.
    def debug(message=nil)
      return unless verbose?
      return puts(stdout, yield) if block_given?
      puts(stdout, message)
    end

    # Logs a message to stdout, runs the given block, and then prints the time
    # it took to run the block.
    def benchmark(message)
      start = Time.now
      print(stdout, "#{message} ")
      debug("\n")
      result = yield
      duration = Time.now - start
      info("✔".green + format(" %0.3fs", duration).gray)
      result
    rescue
      info("✘".red)
      raise
    end

    private

    def print(io, message)
      message = message.strip_color unless color_enabled?
      io.print(message)
    end

    def puts(io, message)
      message = message.strip_color unless color_enabled?
      io.puts(message)
    end

    def color_enabled?
      @color_enabled = determine_color_support if @color_enabled.nil?
      @color_enabled
    end

    def determine_color_support
      if ENV["CLICOLOR_FORCE"] == "1"
        true
      elsif ENV["TERM"] == "dumb"
        false
      else
        tty?(stdout) && tty?(stderr)
      end
    end

    def tty?(io)
      io.respond_to?(:tty?) && io.tty?
    end
  end
end
