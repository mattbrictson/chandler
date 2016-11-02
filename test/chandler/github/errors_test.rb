require "minitest_helper"
require "chandler/github/errors"

class Chandler::GitHub::ErrorsTest < Minitest::Test
  def test_invalid_repository
    invalid_repo = Chandler::GitHub::InvalidRepository.new("user/repo")
    assert_kind_of(Chandler::GitHub::Error, invalid_repo)
    assert_match(/failed to find/i, invalid_repo.message)
    assert_match("user/repo", invalid_repo.message)
  end

  def test_netrc_authentication_failure
    netrc_failure = Chandler::GitHub::NetrcAuthenticationFailure.new
    assert_kind_of(Chandler::GitHub::Error, netrc_failure)
    assert_match(/authentication failed/i, netrc_failure.message)
    assert_match(/netrc/, netrc_failure.message)
  end

  def test_token_authentication_failure
    token_failure = Chandler::GitHub::TokenAuthenticationFailure.new
    assert_kind_of(Chandler::GitHub::Error, token_failure)
    assert_match(/authentication failed/i, token_failure.message)
    assert_match("CHANDLER_GITHUB_API_TOKEN", token_failure.message)
  end
end
