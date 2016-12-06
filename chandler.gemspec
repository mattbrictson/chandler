# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chandler/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= 2.1.0"

  spec.name          = "chandler"
  spec.version       = Chandler::VERSION
  spec.authors       = ["Matt Brictson"]
  spec.email         = ["chandler@mattbrictson.com"]

  spec.summary       = "Syncs CHANGELOG entries to GitHub's release notes"
  spec.homepage      = "https://github.com/mattbrictson/chandler"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "netrc"
  spec.add_dependency "octokit", ">= 2.2.0"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "danger"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "rubocop", ">= 0.37.0"
end
