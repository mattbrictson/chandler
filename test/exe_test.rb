require "minitest_helper"
require "English"

class ExeTest < Minitest::Test
  def test_chandler_is_executable_and_exits_with_success
    within_project_root do
      Bundler.with_clean_env do
        output = `bundle exec chandler --version`
        assert_equal("chandler version #{Chandler::VERSION}\n", output)
        assert($CHILD_STATUS.success?)
      end
    end
  end

  private

  def within_project_root(&block)
    Dir.chdir(File.expand_path("../..", __FILE__), &block)
  end
end
