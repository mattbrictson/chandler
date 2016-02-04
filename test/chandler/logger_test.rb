require "minitest_helper"
require "chandler/logger"

class Chandler::LoggerTest < Minitest::Test
  include LoggerMocks

  def test_color_is_disabled_for_dumb_term
    ENV.stubs(:[]).returns(nil)
    ENV.stubs(:[]).with("TERM").returns("dumb")
    logger = new_logger_with_color
    logger.info("\e[0;31;49mhello\e[0m")
    assert_equal(stdout, "hello\n")
  end

  def test_color_can_be_forced_via_env
    ENV.stubs(:[]).returns(nil)
    ENV.stubs(:[]).with("CLICOLOR_FORCE").returns("1")
    logger = new_logger
    logger.info("\e[0;31;49mhello\e[0m")
    assert_equal(stdout, "\e[0;31;49mhello\e[0m\n")
  end

  def test_debug_disabled_by_default
    block_executed = false
    logger = new_logger
    logger.debug("disabled by default")
    logger.debug do
      block_executed = true
      "disabled by default"
    end
    assert_empty(stdout)
    assert_empty(stderr)
    refute(block_executed)
  end

  def test_debug_is_enabled_in_verbose_mode
    logger = new_logger
    logger.verbose = true

    logger.debug("hello,")
    logger.debug { "world" }
    assert_equal("hello,\nworld\n", stdout)
    assert_empty(stderr)
  end

  def test_error_is_red_by_default
    logger = new_logger_with_color
    logger.error("hello")
    assert_equal("\e[0;31;49mhello\e[0m\n", stderr)
    assert_empty(stdout)
  end

  def test_color_is_passed_through_if_supported_by_output
    logger = new_logger_with_color
    logger.verbose = true

    logger.debug("\e[0;32;49mhello\e[0m")
    logger.info("\e[0;32;49mhello\e[0m")
    logger.error("\e[0;32;49mhello\e[0m")

    assert_equal("\e[0;32;49mhello\e[0m\n\e[0;32;49mhello\e[0m\n", stdout)
    assert_equal("\e[0;32;49mhello\e[0m\n", stderr)
  end

  def test_color_is_stripped_if_not_supported_by_output
    logger = new_logger
    logger.verbose = true

    logger.debug("\e[0;32;49mhello\e[0m")
    logger.info("\e[0;32;49mhello\e[0m")
    logger.error("\e[0;32;49mhello\e[0m")

    assert_equal("hello\nhello\n", stdout)
    assert_equal("hello\n", stderr)
  end

  def test_successful_benchmark
    block_executed = false
    logger = new_logger
    logger.benchmark("test") { block_executed = true }

    assert(block_executed)
    assert_match(/^test ✔ \d\.\d{3}s$/, stdout)
    assert_empty(stderr)
  end

  def test_successful_benchmark_in_color
    block_executed = false
    logger = new_logger_with_color
    logger.benchmark("test") { block_executed = true }

    assert(block_executed)
    assert_match(
      /^test \e\[0;32;49m✔\e\[0m\e\[0;90;49m \d\.\d{3}s\e\[0m$/,
      stdout
    )
    assert_empty(stderr)
  end

  def test_failed_benchmark
    logger = new_logger

    assert_raises("boom!") do
      logger.benchmark("test") { raise "boom!" }
    end

    assert_match(/^test ✘$/, stdout)
    assert_empty(stderr)
  end

  def test_failed_benchmark_in_color
    logger = new_logger_with_color

    assert_raises("boom!") do
      logger.benchmark("test") { raise "boom!" }
    end

    assert_match(
      /^test \e\[0;31;49m✘\e\[0m$/,
      stdout
    )
    assert_empty(stderr)
  end
end
