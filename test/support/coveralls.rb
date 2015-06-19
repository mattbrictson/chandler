if ENV["TRAVIS"]
  require "coveralls"
  Coveralls.wear!
  # Eager load the entire lib directory so that SimpleCov is able to report
  # accurate code coverage metrics.
  chandler_lib = File.expand_path("../../../lib", __FILE__)
  at_exit { Dir["#{chandler_lib}/**/*.rb"].each { |rb| require(rb) } }
end
