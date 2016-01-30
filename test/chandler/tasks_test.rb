require "minitest_helper"
require "rake"
require "chandler/tasks"

class Chandler::TasksTest < Minitest::Test
  def setup
    @gemspec = Gem::Specification.new
    @gemspec.stubs(:version => Gem::Version.new("1.0.2"))
    Bundler::GemHelper.stubs(:gemspec => @gemspec)
  end

  def test_defines_the_chandler_push_rake_task
    assert_instance_of(Rake::Task, Rake.application["chandler:push"])
  end

  def test_push_task_calls_push_command_with_proper_arguments
    config = Chandler::Tasks.config
    push = Chandler::Commands::Push.new(:tags => [], :config => nil)

    Chandler::Commands::Push
      .expects(:new)
      .with(:tags => ["v1.0.2"], :config => config)
      .returns(push)

    push.expects(:call)

    Rake.application["chandler:push"].invoke
  end

  def test_configure_yields_config_object
    config = Chandler::Tasks.config
    assert_equal(config, Chandler::Tasks.configure { |c| c })
  end
end
