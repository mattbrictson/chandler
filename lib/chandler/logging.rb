module Chandler
  # Assuming self responds to `config`, this mixin provides easy access to
  # logging methods by delegating to the configured Logger.
  #
  module Logging
    extend Forwardable
    private def_delegator :config, :logger
    private def_delegator :logger, :benchmark
    private def_delegator :logger, :error
    private def_delegator :logger, :info
  end
end
