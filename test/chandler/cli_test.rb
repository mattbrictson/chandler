require "minitest_helper"
require "chandler/cli"

class Chandler::CLITest < Minitest::Test
  include LoggerMocks

  def setup
    @args = []
    @config = Chandler::Configuration.new
    @config.logger = new_logger
    @parser = stub(:args => @args, :config => @config, :usage => "usage")
    @cli = Chandler::CLI.new(:parser => @parser)
  end

  def test_missing_command_causes_exit
    error = assert_raises(SystemExit) { @cli.run }
    assert_equal(1, error.status)
    assert_match("Please specify a command", stderr)
    assert_match("usage", stdout)
  end

  def test_unrecognized_command_causes_exit
    @args << "blergh"
    error = assert_raises(SystemExit) { @cli.run }
    assert_equal(1, error.status)
    assert_match("Unrecognized command: blergh", stderr)
    assert_match("usage", stdout)
  end

  def test_push_is_invoked_for_all_git_tags_by_default
    @args << "push"
    @config.git.stubs(:version_tags => %w(v1.0.0 v1.0.1))

    Chandler::Commands::Push.expects(:new)
      .with(:tags => %w(v1.0.0 v1.0.1), :config => @config)
      .returns(-> { "pushed" })

    result = @cli.run
    assert_equal("pushed", result)
  end

  def test_push_is_invoked_for_specified_tag
    @args.concat(%w(push v1.0.2))

    Chandler::Commands::Push.expects(:new)
      .with(:tags => %w(v1.0.2), :config => @config)
      .returns(-> { "pushed" })

    result = @cli.run
    assert_equal("pushed", result)
  end
end
