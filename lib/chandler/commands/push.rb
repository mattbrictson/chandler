require "chandler/logging"
require "chandler/refinements/color"
require "chandler/refinements/version_format"
require "forwardable"

module Chandler
  module Commands
    # Iterates over a given array of tags, fetches the corresponding notes
    # from the CHANGELOG, and creates (or updates) the release notes for that
    # tag on GitHub.
    class Push
      extend Forwardable
      def_delegators :config, :github, :changelog, :tag_mapper

      include Logging
      using Chandler::Refinements::Color
      using Chandler::Refinements::VersionFormat

      attr_reader :tags, :config

      def initialize(tags:, config:)
        @tags = tags
        @config = config
      end

      def call
        exit_with_warning if tags.empty?

        each_tag_with_version_and_notes do |tag, version, notes|
          github.create_or_update_release(
            :tag => tag,
            :title => version.version_number,
            :description => notes
          )
        end
      end

      private

      def each_tag_with_version_and_notes
        width = tags.map(&:length).max
        tags.each do |tag|
          version, notes = changelog_version_and_notes_for_tag(tag)
          next if notes.nil?

          ellipsis = "…".ljust(1 + width - tag.length)
          benchmark("Push #{tag.blue}#{ellipsis}") do
            yield(tag, version, notes)
          end
        end
      end

      def exit_with_warning
        error("No version tags found.")
        exit(1)
      end

      def changelog_version_and_notes_for_tag(tag)
        version = tag_mapper.call(tag)
        notes = strip_surrounding_empty_lines(changelog.fetch(version))
        [version, notes]
      rescue Chandler::Changelog::NoMatchingVersion
        info("Skip #{tag} (no #{version} entry in #{changelog.basename})".gray)
        nil
      end

      # Returns a new string with leading and trailing empty lines removed. A
      # line is empty if it is zero-length or contains only whitespace.
      def strip_surrounding_empty_lines(str)
        str.sub(/\A[[:space:]]*^/, "")
           .sub(/$[[:space:]]*\z/, "")
      end
    end
  end
end
