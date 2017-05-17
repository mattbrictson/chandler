require "minitest_helper"
require "chandler/refinements/version_format"
require "chandler/refinements/version"

class Chandler::Refinements::VersionTest < Minitest::Test

  # Test if split of version segments works as expected.
  #
  def test_segments
    assert_equal(3, new_version("1.0.1").segments.size)
    assert_equal(5, new_version("4.2.1-2+b").segments.size)
    assert_equal(1, new_version("4.2.1-2+b").segments[2])
    assert_equal(2, new_version("4.2.1-2+b").segments[3])
  end

  # Test if the comparison of versions works as expected, so that version 11
  # is higher than 2
  def test_compare
    assert_equal(0, new_version("1.0.1") <=> new_version("1.0.1"))
    assert_equal(-1, new_version("1.0.1") <=> new_version("1.0.2"))
    assert_equal(1, new_version("1.0.2") <=> new_version("1.0.1"))
    assert_equal(-1, new_version("1.0.2") <=> new_version("1.0.11"))
  end

  def test_compare_segments
    assert_equal(0, compare_segments([1], [1]))
    assert_equal(-1, compare_segments([1, 2], [1, 11]))
    assert_equal(-1, compare_segments([1, 2], [2]))
    assert_equal(1, compare_segments([2], [1]))
  end

  def test_compare_elements
    assert_equal(-1, compare_elements("", 1))
    assert_equal(1, compare_elements(1, ""))
    assert_equal(-1, compare_elements("1", "2"))
    assert_equal(1, compare_elements(1, 2))
  end

  def test_check_limit
    assert_equal(2, new_version("").get_max_size(1, 2))
    assert_equal(2, new_version("").get_max_size(2, 2))
    assert_equal(1, new_version("").get_max_size(1, 0))
  end

  def new_version(vers)
    Chandler::Refinements::VersionFormat::Version.new(vers)
  end

  def compare_elements(lhsegment, rhsegment)
    new_version("").compare_segments(lhsegment, rhsegment)
  end

  def compare_segments(lhsegment, rhsegment)
    new_version("").compare_segments(lhsegment, rhsegment)
  end
end
