require "minitest_helper"
require "chandler/cli/parser"

class Chandler::CLI::ParserTest < Minitest::Test
  include LoggerMocks

  def test_usage
    parser = parse_arguments
    assert_match(/^Usage: chandler/, parser.usage)
    assert_match("chandler scans your git repository", parser.usage)
    assert_match("--git", parser.usage)
    assert_match("--github", parser.usage)
    assert_match("--changelog", parser.usage)
    assert_match("--dry-run", parser.usage)
    assert_match("--help", parser.usage)
    assert_match("--version", parser.usage)
    assert_match("--tag-prefix", parser.usage)
  end

  def test_args
    assert_equal([], parse_arguments.args)
    assert_equal([], parse_arguments("--dry-run").args)
    assert_equal(["push"], parse_arguments("push").args)
    assert_equal(["push"], parse_arguments("push", "--git=.git").args)
    assert_equal(
      ["push", "v1.0.1"],
      parse_arguments("push", "v1.0.1", "--dry-run").args
    )
  end

  def test_config_is_unchanged_when_no_options_are_specified
    default_config = Chandler::Configuration.new
    config = parse_arguments.config

    assert_equal(config.dry_run?, default_config.dry_run?)
    assert_equal(config.git_path, default_config.git_path)
    assert_equal(config.github_repository, default_config.github_repository)
    assert_equal(config.changelog_path, default_config.changelog_path)
  end

  def test_config_is_changed_based_on_options
    args = %w[
      push
      --git=../test/.git
      --github=test/repo
      --changelog=../test/changes.md
      --tag-prefix=myapp-
      --dry-run
    ]
    config = parse_arguments(*args).config

    assert(config.dry_run?)
    assert_equal("../test/.git", config.git_path)
    assert_equal("test/repo", config.github_repository)
    assert_equal("../test/changes.md", config.changelog_path)
    assert_equal("myapp-", config.tag_prefix)
  end

  def test_prints_version_and_exits
    exit = assert_raises(SystemExit) { parse_arguments("--version") }
    assert_equal(0, exit.status)
    assert_equal("chandler version #{Chandler::VERSION}\n", stdout)
  end

  def test_prints_usage_and_exits
    exit = assert_raises(SystemExit) { parse_arguments("--help") }
    assert_equal(0, exit.status)
  end

  private

  def parse_arguments(*args)
    config = Chandler::Configuration.new
    config.logger = new_logger
    Chandler::CLI::Parser.new(args, config)
  end
end
