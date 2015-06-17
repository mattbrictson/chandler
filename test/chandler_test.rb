require "minitest_helper"
require "chandler"

class ChandlerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil(::Chandler::VERSION)
  end
end
