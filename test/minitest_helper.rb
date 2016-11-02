$LOAD_PATH.unshift(File.expand_path("../../lib", __FILE__))

# Simplecov has to be loaded first
require_relative("./support/simplecov")

# Load everything else from test/support
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |rb| require(rb) }

require "minitest/autorun"
