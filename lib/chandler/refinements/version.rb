module Chandler
  module Refinements
    module VersionFormat
      # Version Class to be able to compare two objects for sorting versions
      class Version
        attr_accessor :version

        def initialize(version)
          @version = version
        end

        # Compare two versions
        def <=>(other)
          # rubocop:disable CaseEquality
          return unless Chandler::Refinements::VersionFormat::Version === other
          return 0 if self == other
          compare_segments(segments, other.segments)
        end

        def compare_segments(lhsegments, rhsegments)
          result = 0
          lhsegments.zip(rhsegments).each do |lhs, rhs|
            result = compare_elements(lhs || 0, rhs || 0)
            break if result != 0
          end
          result
        end

        def compare_elements(lhs, rhs)
          return -1 if lhs.is_a?(String) && rhs.is_a?(Numeric)
          return 1 if lhs.is_a?(Numeric) && rhs.is_a?(String)
          lhs <=> rhs
        end

        # Split version string into segments
        # and transform to integer, if possible
        def segments
          @segments ||= @version.scan(/#{VERSION_SEGMENT_PATTERN}+/i).map do |s|
            /^\d+$/ =~ s ? s.to_i : s
          end
        end
      end
    end
  end
end
