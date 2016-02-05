require "minitest_helper"
require "English"
require "fileutils"
require "tempfile"
require "chandler/git"

class Chandler::GitTest < Minitest::Test
  def test_version_tags_for_empty_repo
    create_git_repo
    assert_equal([], subject.version_tags)
  end

  def test_version_tags
    create_git_repo do
      git("commit --allow-empty -m 1")
      git("tag -a v0.1.0 -m 0.1.0")
      git("commit --allow-empty -m 2")
      git("tag -a v0.2.0 -m 0.2.0")
      git("commit --allow-empty -m 2")
      git("tag -a v0.11.0 -m 0.11.0")
      git("tag -a wip -m wip")
    end
    assert_equal(%w(v0.1.0 v0.2.0 v0.11.0), subject.version_tags)
  end

  def test_version_tags_with_prefix
    create_git_repo do
      git("commit --allow-empty -m 1")
      git("tag -a myapp-0.1.0 -m 0.1.0")
      git("commit --allow-empty -m 2")
      git("tag -a myapp-0.2.0 -m 0.2.0")
      git("commit --allow-empty -m 2")
      git("tag -a myapp-0.11.0 -m 0.11.0")
      git("tag -a wip -m wip")
    end
    mapper = ->(tag) { tag[/myapp-(.*)/, 1] }
    assert_equal(
      %w(myapp-0.1.0 myapp-0.2.0 myapp-0.11.0),
      subject(mapper).version_tags
    )
  end

  def test_origin_remote_for_empty_repo
    create_git_repo
    assert_nil(subject.origin_remote)
  end

  def test_origin_remote
    create_git_repo do
      git("remote add upstream git@example.com:username/upstream")
      git("remote add origin git@example.com:username/origin")
    end
    assert_equal("git@example.com:username/origin", subject.origin_remote)
  end

  def test_error_includes_descriptive_message
    error = assert_raises(Chandler::Git::Error) do
      @git_path = "non-existent-path"
      subject.origin_remote
    end
    assert_match("Failed to execute: git", error.message)
    assert_match("Not a git repository: 'non-existent-path'", error.message)
  end

  private

  def subject(mapper=->(tag) { tag })
    @git ||= Chandler::Git.new(:path => @git_path, :tag_mapper => mapper)
  end

  def create_git_repo
    tempdir = Dir.mktmpdir("chandler-git-test-")
    @git_path = File.join(tempdir, ".git")
    at_exit { FileUtils.remove_entry(tempdir) }

    Dir.chdir(tempdir) do
      git("init")
      git("config user.email test@example.com")
      git("config user.name test")
      yield if block_given?
    end
  end

  def git(command)
    `git #{command}`
    raise unless $CHILD_STATUS.success?
  end
end
