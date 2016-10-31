require "minitest_helper"
require "chandler/github/client"

class Chandler::GitHub::ClientTest < Minitest::Test
  class FakeOctokitClient
    attr_reader :netrc, :access_token, :api_endpoint

    def initialize(options)
      @netrc = options.fetch(:netrc, false)
      @access_token = options[:access_token]
      @api_endpoint = options[:api_endpoint] if options[:api_endpoint]
    end

    def login
      "successful"
    end
  end

  class FakeOctokitClientWithError < FakeOctokitClient
    def login
      nil
    end
  end

  def test_uses_netrc_by_default
    client = Chandler::GitHub::Client.new(:octokit_client => FakeOctokitClient)
    assert(client.netrc)
    assert_nil(client.access_token)
  end

  def test_uses_access_token_from_env
    client = Chandler::GitHub::Client.new(
      :environment => { "CHANDLER_GITHUB_API_TOKEN" => "foo" },
      :octokit_client => FakeOctokitClient
    )
    assert_equal("foo", client.access_token)
    refute(client.netrc)
  end

  def test_doesnt_change_default_endpoint_for_public_github
    client = Chandler::GitHub::Client.new(
      :host => "github.com",
      :octokit_client => FakeOctokitClient
    )
    assert_nil(client.api_endpoint)
  end

  def test_assigns_enterprise_endpoint
    client = Chandler::GitHub::Client.new(
      :host => "github.example.com",
      :octokit_client => FakeOctokitClient
    )
    assert_equal("https://github.example.com/api/v3/", client.api_endpoint)
  end

  def test_raises_exception_if_netrc_fails
    assert_raises(Chandler::GitHub::NetrcAuthenticationFailure) do
      Chandler::GitHub::Client.new(
        :octokit_client => FakeOctokitClientWithError
      ).login!
    end
  end

  def test_raises_exception_if_access_token_fails
    assert_raises(Chandler::GitHub::TokenAuthenticationFailure) do
      Chandler::GitHub::Client.new(
        :environment => { "CHANDLER_GITHUB_API_TOKEN" => "foo" },
        :octokit_client => FakeOctokitClientWithError
      ).login!
    end
  end
end
