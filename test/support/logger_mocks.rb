require "stringio"
require "chandler/logger"

module LoggerMocks
  class ColorfulStringIO < StringIO
    def tty?
      true
    end
  end

  private

  def stdout
    @stdout.string
  end

  def stderr
    @stderr.string
  end

  def new_logger
    @stderr = StringIO.new
    @stdout = StringIO.new
    Chandler::Logger.new(:stderr => @stderr, :stdout => @stdout)
  end

  def new_logger_with_color
    @stderr = ColorfulStringIO.new
    @stdout = ColorfulStringIO.new
    Chandler::Logger.new(:stderr => @stderr, :stdout => @stdout)
  end
end
