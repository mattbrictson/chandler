require "minitest_helper"
require "chandler/github/remote"

class Chandler::GitHub::RemoteTest < Minitest::Test
  def test_bare_repository_name
    repo = parse("mattbrictson/chandler")
    assert_equal("github.com", repo.host)
    assert_equal("mattbrictson/chandler", repo.repository)
  end

  def test_ssh_style_url
    repo = parse("git@github.com:mattbrictson/chandler.git")
    assert_equal("github.com", repo.host)
    assert_equal("mattbrictson/chandler", repo.repository)
  end

  def test_https_url
    repo = parse("https://github.com/mattbrictson/chandler.git")
    assert_equal("github.com", repo.host)
    assert_equal("mattbrictson/chandler", repo.repository)
  end

  def test_enterprise_ssh_style_url
    repo = parse("git@github.example.com:org/project.git")
    assert_equal("github.example.com", repo.host)
    assert_equal("org/project", repo.repository)
  end

  private

  def parse(url)
    Chandler::GitHub::Remote.parse(url)
  end
end
