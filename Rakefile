require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "chandler/tasks"
task "release:rubygem_push" => "chandler:push"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

RuboCop::RakeTask.new

task :default => %i[test rubocop]
