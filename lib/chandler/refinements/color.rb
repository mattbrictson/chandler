module Chandler
  module Refinements
    # Monkey patch String to provide basic ANSI color support.
    #
    # "hello".color? # => false
    # "hello".blue # => "\e[0;34;49mhello\e[0m"
    # "hello".blue.color? # => true
    # "hello".blue.strip_color # "hello"
    #
    module Color
      ANSI_CODES = {
        :red   => 31,
        :green => 32,
        :blue  => 34,
        :gray  => 90,
        :grey  => 90
      }.freeze

      refine String do
        # Returns `true` if this String contains ANSI color sequences.
        def color?
          self != strip_color
        end

        # Returns a new String with ANSI color sequences removed.
        def strip_color
          gsub(/\e\[[0-9;]*m/, "")
        end

        # Define red, green, blue, etc. methods that return a copy of the
        # String that is wrapped in the corresponding ANSI color escape
        # sequence.
        ANSI_CODES.each do |name, code|
          define_method(name) do
            "\e[0;#{code};49m#{self}\e[0m"
          end
        end
      end
    end
  end
end
