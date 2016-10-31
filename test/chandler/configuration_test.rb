require "minitest_helper"
require "chandler/configuration"

class Chandler::ConfigurationTest < Minitest::Test
  def setup
    @config = Chandler::Configuration.new
  end

  def test_defaults
    assert_equal("CHANGELOG.md", @config.changelog_path)
    assert_equal(".git", @config.git_path)
    assert_instance_of(Chandler::Logger, @config.logger)
    refute(@config.logger.verbose?)
    refute(@config.dry_run?)
  end

  def test_default_git
    @config.git_path = "../test/.git"
    git = @config.git
    assert_instance_of(Chandler::Git, git)
    assert_equal("../test/.git", git.path)
    assert_equal(:itself, git.tag_mapper.call(:itself))
  end

  def test_prefixed_git
    @config.git_path = "../test/.git"
    @config.tag_prefix = "myapp-"
    mapper = @config.git.tag_mapper
    assert_nil(mapper.call("1.0.1"))
    assert_nil(mapper.call("whatever-2.5.2"))
    assert_equal("3.1.9", mapper.call("myapp-3.1.9"))
  end

  def test_explict_github_repository
    @config.github_repository = "test/repo"
    github = @config.github
    assert_instance_of(Chandler::GitHub, github)
    assert_equal("test/repo", github.repository)
  end

  def test_implict_github_repository
    git = @config.git
    git.expects(:origin_remote).returns("test/repo")
    github = @config.github
    assert_instance_of(Chandler::GitHub, github)
    assert_equal("test/repo", github.repository)
  end

  def test_changelog
    @config.changelog_path = "../test/history.md"
    changelog = @config.changelog
    assert_instance_of(Chandler::Changelog, changelog)
    assert_equal("../test/history.md", changelog.path)
  end
end
