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

        benchmarking_each_tag do |tag, version|
          github.create_or_update_release(
            :tag => tag,
            :title => tag.version_number,
            :description => changelog.fetch(version).strip
          )
        end
      end

      private

      def benchmarking_each_tag
        width = tags.map(&:length).max
        tags.each do |tag|
          ellipsis = "…".ljust(1 + width - tag.length)
          benchmark("Push #{tag.blue}#{ellipsis}") do
            yield(tag, tag_mapper.call(tag))
          end
        end
      end

      def exit_with_warning
        error("No version tags found.")
        exit(1)
      end
    end
  end
end
