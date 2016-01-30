require "minitest_helper"
require "chandler/configuration"
require "chandler/github"

class Chandler::GitHubTest < Minitest::Test
  def setup
    @config = Chandler::Configuration.new

    @octokit = Octokit::Client.new
    @octokit.stubs(:login => "mattbrictson")
    Octokit::Client.stubs(:new).with(:netrc => true).returns(@octokit)

    @github = Chandler::GitHub.new(:repository => "repo", :config => @config)
  end

  def test_fails_if_missing_credentials
    @octokit.stubs(:login => nil)

    assert_raises(Chandler::GitHub::MissingCredentials) do
      @github.create_or_update_release(
        :tag => "v1.0.2",
        :title => "1.0.2",
        :description => "Fix a bug"
      )
    end
  end

  def test_dry_run_disables_all_api_calls
    @octokit.expects(:release_for_tag).never
    @octokit.expects(:create_release).never
    @octokit.expects(:update_release).never

    @config.dry_run = true
    @github.create_or_update_release(
      :tag => "v1.0.2",
      :title => "1.0.2",
      :description => "Fix a bug"
    )
  end

  def test_no_update_performed_if_release_has_not_changed
    tag = "v1.0.2"
    title = "1.0.2"
    desc = "desc"
    release = stub(:id => "id", :name => title, :body => desc)

    @octokit.expects(:release_for_tag).with("repo", tag).returns(release)
    @octokit.expects(:create_release).never
    @octokit.expects(:update_release).never

    @github.create_or_update_release(
      :tag => tag,
      :title => title,
      :description => desc
    )
  end

  def test_update_performed_if_release_exists_and_is_different
    tag = "v1.0.2"
    title = "1.0.2"
    desc = "desc"
    release = stub(:id => "id", :url => "url", :name => title, :body => "old")

    @octokit.expects(:release_for_tag).with("repo", tag).returns(release)
    @octokit.expects(:update_release)
            .with("url", :name => title, :body => desc)
    @octokit.expects(:create_release).never

    @github.create_or_update_release(
      :tag => tag,
      :title => title,
      :description => desc
    )
  end

  def test_create_performed_if_existing_release_404s
    tag = "v1.0.2"
    title = "1.0.2"
    desc = "desc"

    @octokit.expects(:release_for_tag)
            .with("repo", tag)
            .raises(Octokit::NotFound)

    @octokit.expects(:create_release)
            .with("repo", tag, :name => title, :body => desc)

    @octokit.expects(:update_release).never

    @github.create_or_update_release(
      :tag => tag,
      :title => title,
      :description => desc
    )
  end

  def test_create_performed_if_existing_release_has_nil_id
    tag = "v1.0.2"
    title = "1.0.2"
    desc = "desc"
    release = stub(:id => nil)

    @octokit.expects(:release_for_tag).with("repo", tag).returns(release)

    @octokit.expects(:create_release)
            .with("repo", tag, :name => title, :body => desc)

    @octokit.expects(:update_release).never

    @github.create_or_update_release(
      :tag => tag,
      :title => title,
      :description => desc
    )
  end
end
