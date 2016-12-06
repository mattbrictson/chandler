require "minitest_helper"
require "chandler/configuration"
require "chandler/logging"

class Chandler::LoggingTest < Minitest::Test
  class Subject
    include Chandler::Logging
    attr_reader :config
    def initialize
      @config = Chandler::Configuration.new
    end
  end

  def test_forwards_to_config_logger
    subject = Subject.new
    logger = subject.config.logger

    logger.expects(:benchmark)
    logger.expects(:error)
    logger.expects(:info)

    subject.send(:benchmark)
    subject.send(:error)
    subject.send(:info)
  end

  def test_methods_are_private
    subject = Subject.new

    assert_includes(subject.private_methods, :logger)
    assert_includes(subject.private_methods, :benchmark)
    assert_includes(subject.private_methods, :error)
    assert_includes(subject.private_methods, :info)
  end
end
