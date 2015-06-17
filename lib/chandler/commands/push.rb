require "chandler/logging"
require "chandler/refinements/color"
require "chandler/refinements/version_format"

module Chandler
  module Commands
    # Iterates over a given array of tags, fetches the corresponding notes
    # from the CHANGELOG, and creates (or updates) the release notes for that
    # tag on GitHub.
    class Push
      include Logging
      using Chandler::Refinements::Color
      using Chandler::Refinements::VersionFormat

      attr_reader :github, :changelog, :tags, :config

      def initialize(tags:, config:)
        @tags = tags
        @github = config.github
        @changelog = config.changelog
        @config = config
      end

      def call
        benchmarking_each_tag do |tag|
          github.create_or_update_release(
            :tag => tag,
            :title => tag.version_number,
            :description => changelog.fetch(tag).strip
          )
        end
      end

      private

      def benchmarking_each_tag
        width = tags.map(&:length).max
        tags.each do |tag|
          ellipsis = "…".ljust(1 + width - tag.length)
          benchmark("Push #{tag.blue}#{ellipsis}") do
            yield(tag)
          end
        end
      end
    end
  end
end
