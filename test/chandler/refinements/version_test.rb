require "minitest_helper"
require "chandler/refinements/version_format"
require "chandler/refinements/version"

class Chandler::Refinements::VersionTest < Minitest::Test

  # Test if split of version segments works as expected.
  #
  def test_segments
    oneZeroOne=Chandler::Refinements::VersionFormat::Version.new("1.0.1")
    assert_equal(3, oneZeroOne.segments.size)
    complex=Chandler::Refinements::VersionFormat::Version.new("4.2.1-2+b")
    assert_equal(5, complex.segments.size)
    assert_equal(1, complex.segments[2])
    assert_equal(2, complex.segments[3])
  end

  # Test if the comparison of versions works as expected, so that version 11 is higher than 2
  #
  def test_compare
    oneZeroOne=Chandler::Refinements::VersionFormat::Version.new("1.0.1")
    oneZeroTwo=Chandler::Refinements::VersionFormat::Version.new("1.0.2")
    oneZeroEleven=Chandler::Refinements::VersionFormat::Version.new("1.0.11")
    assert_equal(0, oneZeroOne <=> oneZeroOne)
    assert_equal(-1, oneZeroOne <=> oneZeroTwo)
    assert_equal(1, oneZeroTwo <=> oneZeroOne)
    assert_equal(-1, oneZeroTwo <=> oneZeroEleven)
  end
end
