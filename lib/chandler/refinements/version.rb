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
          lhsegments = segments
          rhsegments = other.segments
          return compare_segments(lhsegments, rhsegments)
        end

        def compare_segments(lhsegments, rhsegments)
          limit = get_max_size(lhsegments.size, rhsegments.size) -1
          i = 0
          result = 0
          while i <= limit
            lhs = lhsegments[i] || 0
            rhs = rhsegments[i] || 0
            result = compare_elements(lhs, rhs)
            break if result != 0
            i += 1
          end
          result
        end

        def compare_elements(lhs, rhs)
          return -1 if String == lhs && Numeric == rhs
          return 1 if Numeric == lhs && String == rhs
          lhs <=> rhs
        end

        def get_max_size(lhsize, rhsize)
          return (lhsize > rhsize ? lhsize : rhsize)
        end

        #
        # Split version string into segments
        def segments
          @segments ||= @version.scan(/#{VERSION_SEGMENT_PATTERN}+/i).map do |s|
            /^\d+$/ =~ s ? s.to_i : s
          end
        end
      end
    end
  end
end
