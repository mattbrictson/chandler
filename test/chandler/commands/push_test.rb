require "minitest_helper"
require "chandler/configuration"
require "chandler/github"
require "chandler/commands/push"

class Chandler::Commands::PushTest < Minitest::Test
  include LoggerMocks

  def setup
    @github = Chandler::GitHub.new(
      :repository => "",
      :config => nil
    )
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

  def test_changelog_is_used_to_obtain_notes_using_tag_mapper
    @config.stubs(:tag_mapper).returns(->(_tag) { "foo" })
    @config.changelog.expects(:fetch).with("foo").returns("notes")
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

  def test_tag_prefix_is_removed_from_title_when_pushing_to_github
    @config.tag_prefix = "app-"
    @github
      .expects(:create_or_update_release)
      .with(:tag => "app-1", :title => "1", :description => "notes")

    push = Chandler::Commands::Push.new(:tags => %w(app-1), :config => @config)
    push.call
  end

  def test_leading_and_trailing_blank_lines_are_stripped_when_pushing_to_github
    @config.changelog
           .expects(:fetch).with("v1")
           .returns("\n\n  * one\n\n  * two\n\n")
    @github.unstub(:create_or_update_release)
    @github
      .expects(:create_or_update_release)
      .with(:tag => "v1", :title => "1", :description => "  * one\n\n  * two")

    push = Chandler::Commands::Push.new(:tags => %w(v1), :config => @config)
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

  def test_skipped_tag_is_printed_to_stdout
    @config.changelog
           .stubs(:fetch)
           .with("v2.0.2")
           .raises(Chandler::Changelog::NoMatchingVersion)

    push = Chandler::Commands::Push.new(
      :tags => %w(v1 v2.0.2 v99.1.18),
      :config => @config
    )
    push.call

    assert_match("Push v1…       ✔", stdout)
    refute_match("Push v2.0.2…   ✔", stdout)
    assert_match("Skip v2.0.2 (no v2.0.2 entry in CHANGELOG.md)", stdout)
    assert_match("Push v99.1.18… ✔", stdout)
  end

  def test_exits_with_warning_if_no_tags
    push = Chandler::Commands::Push.new(:tags => [], :config => @config)

    Mocha::Configuration.allow(:stubbing_non_public_method) do
      push.expects(:exit).with(1).throws(:exited)
    end

    assert_throws(:exited) { push.call }
    assert_match(/no version tags/i, stderr)
  end
end
