require 'bundler'
require "bundler/setup"
require "rubygems"

Bundler::GemHelper.install_tasks

PROJECT_ROOT = File.expand_path("..", __FILE__)
$:.unshift "#{PROJECT_ROOT}/lib"

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


# other Project tasks
Dir[File.join(File.dirname(__FILE__),"tasks","*.rb")].each {|file| require file }

namespace :jsmetrics do
  desc "master build"
  task :build => [:spec, "cucumber"]
end

task :default => ["jsmetrics:build"]



