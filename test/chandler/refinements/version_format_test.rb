require "minitest_helper"
require "chandler/refinements/version_format"

class Chandler::Refinements::VersionFormatTest < Minitest::Test
  using Chandler::Refinements::VersionFormat

  def test_version?
    assert("1.0.1".version?)
    assert("v1.0.1".version?)
    assert("4.2.1.rc4".version?)
    assert("v4.2.1.rc4".version?)
    assert("v4.2.1.rc4".version?)
    assert("4.2.1-20170405101014+6175caa9d4db01".version?)
    refute("wut".version?)
    refute("2 point oh".version?)
    refute("4 2 1".version?)
  end

  def test_version_number
    assert_equal("1.0.1", "1.0.1".version_number)
    assert_equal("1.0.1", "v1.0.1".version_number)
    assert_equal("4.2.1.rc4", "4.2.1.rc4".version_number)
    assert_equal("4.2.1.rc4", "v4.2.1.rc4".version_number)
    assert_equal("4.2.1-2017+61a", "4.2.1-2017+61a".version_number)
    assert_nil("wut".version_number)
    assert_nil("2 point oh".version_number)
  end

  def test_version_tag
    assert_equal("v1.0.1", "1.0.1".version_tag)
    assert_equal("v1.0.1", "v1.0.1".version_tag)
    assert_equal("v4.2.1.rc4", "4.2.1.rc4".version_tag)
    assert_equal("v4.2.1.rc4", "v4.2.1.rc4".version_tag)
    assert_equal("v4.2.1-2017+61c", "4.2.1-2017+61c".version_tag)
    assert_nil("wut".version_tag)
    assert_nil("2 point oh".version_tag)
  end
end
