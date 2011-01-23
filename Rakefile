require(File.join(File.dirname(__FILE__), 'boot'))
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

# Cucumber configurations

require 'cucumber/rake/task'
Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = "--format pretty"
end

# RSpec

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)


# Build tasks

namespace :jsmetrics do
  desc "master build"
  task :build => [:spec,"cucumber"] 
end

task :default => ["jsmetrics:build"]

