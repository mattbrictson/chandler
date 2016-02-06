require "chandler/refinements/version_format"

module Chandler
  # Responsible for parsing a CHANGELOG into a hash of release notes keyed
  # by version number. Release notes for a particular version or tag can be
  # accessed using the `fetch` method.
  class Changelog
    using Chandler::Refinements::VersionFormat

    NoMatchingVersion = Class.new(StandardError)

    HEADING_PATTERNS = [
      /^#[[:space:]]+.*\n/,   # Markdown "atx" style
      /^##[[:space:]]+.*\n/,
      /^###[[:space:]]+.*\n/,
      /^=[[:space:]]+.*\n/,   # Rdoc style
      /^==[[:space:]]+.*\n/,
      /^===[[:space:]]+.*\n/,
      /^\S.*\n-+\n/           # Markdown "Setext" style
    ].freeze

    attr_reader :path

    def initialize(path:)
      @path = path
    end

    # Fetch release notes for the given tag or version number.
    #
    # E.g.
    # fetch("v1.0.1") # => "\nRelease notes for 1.0.1.\n"
    # fetch("1.0.1")  # => "\nRelease notes for 1.0.1.\n"
    # fetch("blergh") # => Chandler::NoMatchingVersion
    #
    def fetch(tag)
      versions.fetch(tag.version_number) do
        raise NoMatchingVersion, "Couldn’t find #{tag} in #{path}"
      end
    end

    def basename
      File.basename(path.to_s)
    end

    private

    # Transforms the changelog into a hash where the keys are version numbers
    # and the values are the release notes for those versions. The values are
    # *not* stripped of whitespace.
    #
    # The version numbers are assumed to be contained at Markdown or Rdoc
    # headings. The release notes for those version numbers are the text
    # delimited by those headings. The algorithm tries various styles of these
    # Markdown and Rdoc headings (see `HEADING_PATTERNS`).
    #
    # The resulting hash entries look like:
    # { "1.0.1" => "\nRelease notes for 1.0.1.\n" }
    #
    def versions
      @versions ||= begin
        HEADING_PATTERNS.reduce({}) do |found, heading_re|
          versions_at_headings(heading_re).merge(found)
        end
      end
    end

    # rubocop:disable Style/SymbolProc
    def versions_at_headings(heading_re)
      sections(heading_re).each_with_object({}) do |(heading, text), versions|
        tokens = heading.gsub(/[\[\]\(\)`]/, " ").split(/[[:space:]]/)
        tokens = tokens.map(&:strip)
        version = tokens.find { |t| t.version? }
        versions[version.version_number] = text if version
      end
    end
    # rubocop:enable Style/SymbolProc

    # Parses the changelog into a hash, where the keys of the hash are the
    # Markdown/rdoc headings matching the specified heading regexp, and values
    # are the content delimited by those headings.
    #
    # E.g.
    # { "## v1.0.1\n" => "\nRelease notes for 1.0.1.\n" }
    #
    def sections(heading_re)
      hash = {}
      heading = ""
      remainder = text

      until remainder.empty?
        hash[heading], heading, remainder = remainder.partition(heading_re)
      end

      hash
    end

    def text
      @text ||= IO.read(path, :encoding => "UTF-8")
    end
  end
end
