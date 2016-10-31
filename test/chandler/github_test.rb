require "minitest_helper"
require "chandler/configuration"
require "chandler/github"

class Chandler::GitHubTest < Minitest::Test
  def setup
    @config = Chandler::Configuration.new

    @client = Chandler::GitHub::Client.new
    @client.stubs(:login).returns("username")
    Chandler::GitHub::Client
      .stubs(:new)
      .with(:host => "github.com")
      .returns(@client)

    @github = Chandler::GitHub.new(:repository => "repo", :config => @config)
  end

  def test_dry_run_disables_all_api_calls
    @client.expects(:release_for_tag).never
    @client.expects(:create_release).never
    @client.expects(:update_release).never

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

    @client.expects(:release_for_tag).with("repo", tag).returns(release)
    @client.expects(:create_release).never
    @client.expects(:update_release).never

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

    @client.expects(:release_for_tag).with("repo", tag).returns(release)
    @client.expects(:update_release)
           .with("url", :name => title, :body => desc)
    @client.expects(:create_release).never

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

    @client.expects(:release_for_tag)
           .with("repo", tag)
           .raises(Octokit::NotFound)

    @client.expects(:create_release)
           .with("repo", tag, :name => title, :body => desc)

    @client.expects(:update_release).never

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

    @client.expects(:release_for_tag).with("repo", tag).returns(release)

    @client.expects(:create_release)
           .with("repo", tag, :name => title, :body => desc)

    @client.expects(:update_release).never

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
