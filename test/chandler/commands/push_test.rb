require "minitest_helper"
require "chandler/configuration"
require "chandler/github"
require "chandler/commands/push"

class Chandler::Commands::PushTest < Minitest::Test
  include LoggerMocks

  def setup
    @github = Chandler::GitHub.new(:repository => "", :config => nil)
    @github.stubs(:create_or_update_release)

    @config = Chandler::Configuration.new
    @config.logger = new_logger
    @config.stubs(:github => @github)
    @config.changelog.stubs(:fetch => "notes")
  end

  def test_changelog_is_used_to_obtain_notes
    @config.changelog.expects(:fetch).with("v1").returns("notes")
    push = Chandler::Commands::Push.new(:tags => %w(v1), :config => @config)
    push.call
  end

  def test_github_is_used_to_create_or_update_releases
    @github
      .expects(:create_or_update_release)
      .with(:tag => "v1", :title => "1", :description => "notes")

    @github
      .expects(:create_or_update_release)
      .with(:tag => "v2", :title => "2", :description => "notes")

    push = Chandler::Commands::Push.new(:tags => %w(v1 v2), :config => @config)
    push.call
  end

  def test_progress_is_pretty_printed_to_stdout
    push = Chandler::Commands::Push.new(
      :tags => %w(v1 v2.0.2 v99.1.18),
      :config => @config
    )
    push.call

    assert_match("Push v1…       ✔", stdout)
    assert_match("Push v2.0.2…   ✔", stdout)
    assert_match("Push v99.1.18… ✔", stdout)
  end
end
