module Chandler
  module Refinements
    # Monkey patch String to provide conveniences for identifying strings that
    # represent a version, and converting between between tags (e.g "v1.0.2")
    # and version numbers ("1.0.2").
    #
    module VersionFormat
      refine String do

        VERSION_SEGMENT_PATTERN="[0-9a-zA-Z]"

        # Does this string represent a version?
        #
        # "1.0.2".version?  # => true
        # "v1.0.2".version? # => true
        # "nope".version?   # => false
        # "".version?       # => false
        #
        def version?
          !!version_number
        end

        # The version number portion of the string, with the optional "v"
        # prefix removed.
        #
        # "1.0.2".version_number  # => "1.0.2"
        # "v1.0.2".version_number # => "1.0.2"
        # "nope".version_number   # => nil
        # "".version_number       # => nil
        #
        def version_number
          self[/^v?([0-9]+([.+-]#{VERSION_SEGMENT_PATTERN}+)*)$/, 1]
        end

        # The version number reformatted as a tag, by prefixing "v".
        #
        # "1.0.2".version_tag  # => "v1.0.2"
        # "v1.0.2".version_tag # => "v1.0.2"
        # "nope".version_tag   # => nil
        # "".version_tag       # => nil
        #
        def version_tag
          number = version_number
          number && "v#{version_number}"
        end

      end
    end
  end
end
