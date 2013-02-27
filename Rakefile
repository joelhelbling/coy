require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
  t.pattern = 'spec/lib/**/*_spec.rb'
  t.rspec_opts = " --format doc"
end

Cucumber::Rake::Task.new(:cukes) do |t|
  t.cucumber_opts = "features --format pretty"
end

task default: :spec
