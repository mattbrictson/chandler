require "minitest_helper"
require "chandler/configuration"
require "chandler/github"

class Chandler::GitHubSetupTest < Minitest::Test
  def test_auths_with_access_token
    access_token = "12345"

    mocked_client = MiniTest::Mock.new
    mocked_client.expect(:login, :access_token => access_token)

    config = Chandler::Configuration.new
    config.environment = { "CHANDLER_GITHUB_API_TOKEN" => access_token }

    Octokit::Client.stubs(:new)
                   .with(:access_token => access_token).returns(mocked_client)

    github = Chandler::GitHub.new(
      :repository => "repo",
      :config => config
    )
    github.send(:client)
    mocked_client.verify
  end
end

class Chandler::GitHubInteractionTest < Minitest::Test
  def setup
    @config = Chandler::Configuration.new

    @octokit = Octokit::Client.new(:netrc => true)
    @octokit.stubs(:login => "mattbrictson")
    @config.stubs(:octokit).returns(@octokit)

    @github = Chandler::GitHub.new(
      :repository => "repo",
      :config => @config
    )
  end

  def test_fails_if_missing_credentials
    @octokit.stubs(:login => nil)

    assert_raises(Chandler::GitHub::NetrcAuthenticationFailure) do
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

  def test_raises_exception_if_repo_doesnt_exist
    @client.expects(:release_for_tag).raises(Octokit::NotFound)
    @client.expects(:create_release).raises(Octokit::NotFound)

    assert_raises(Chandler::GitHub::InvalidRepository) do
      @github.create_or_update_release(
        :tag => "v1.0.2",
        :title => "1.0.2",
        :description => "desc"
      )
    end
  end
end
