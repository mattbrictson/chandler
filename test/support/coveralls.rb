if ENV["TRAVIS"]
  require "simplecov"
  require "coveralls"

  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  SimpleCov.start do
    # No need to report coverage metrics for the test code
    add_filter "test"
  end

  # Eager load the entire lib directory so that SimpleCov is able to report
  # accurate code coverage metrics.
  chandler_lib = File.expand_path("../../../lib", __FILE__)
  at_exit { Dir["#{chandler_lib}/**/*.rb"].each { |rb| require(rb) } }
end
