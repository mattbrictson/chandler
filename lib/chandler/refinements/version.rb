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
          return unless Chandler::Refinements::VersionFormat::Version === other
          return 0 if self == other

          lhsegments = segments
          rhsegments = other.segments

          lhsize = lhsegments.size
          rhsize = rhsegments.size
          limit  = (lhsize > rhsize ? lhsize : rhsize) - 1

          i = 0

          while i <= limit
            lhs, rhs = lhsegments[i] || 0, rhsegments[i] || 0
            i += 1

            next      if lhs == rhs
            return -1 if String  === lhs && Numeric === rhs
            return  1 if Numeric === lhs && String  === rhs

            return lhs <=> rhs
          end
        end

        #
        #Split version string into segments
        def segments
          @segments ||= @version.scan(/#{VERSION_SEGMENT_PATTERN}+/i).map do |s|
            /^\d+$/ =~ s ? s.to_i : s
          end
        end
      end
    end
  end
end
