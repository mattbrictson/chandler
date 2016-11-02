require "bundler/gem_helper"
require "chandler/configuration"
require "chandler/refinements/version_format"
require "chandler/commands/push"
require "rake"

using Chandler::Refinements::VersionFormat

namespace :chandler do
  desc "Push release notes for the current version to GitHub"
  task "push" do
    gemspec = Bundler::GemHelper.gemspec
    push = Chandler::Commands::Push.new(
      :tags => [gemspec.version.to_s.version_tag],
      :config => Chandler::Tasks.config
    )
    push.call
  end
end

module Chandler
  module Tasks
    def self.config
      @configuration ||= Chandler::Configuration.new
    end

    def self.configure
      yield(config)
    end
  end
end
