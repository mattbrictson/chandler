require "minitest_helper"
require "chandler/refinements/color"

class Chandler::Refinements::ColorTest < Minitest::Test
  using Chandler::Refinements::Color

  def test_color?
    refute("hello".color?)
    assert("\e[0;34;49mhello\e[0m".color?)
  end

  def test_strip_color
    assert_equal("hello", "hello".strip_color)
    assert_equal("hello", "\e[0;34;49mhello\e[0m".strip_color)
  end

  def test_red
    assert_equal("\e[0;31;49mhello\e[0m", "hello".red)
  end

  def test_green
    assert_equal("\e[0;32;49mhello\e[0m", "hello".green)
  end

  def test_blue
    assert_equal("\e[0;34;49mhello\e[0m", "hello".blue)
  end

  def test_gray
    assert_equal("\e[0;90;49mhello\e[0m", "hello".gray)
  end

  def test_grey
    assert_equal("\e[0;90;49mhello\e[0m", "hello".grey)
  end
end
