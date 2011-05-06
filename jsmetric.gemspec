# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "version"

Gem::Specification.new do |s|
  s.name        = "jsmetric"
  s.version     = Jsmetric::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nigel Fernandes"]
  s.email       = ["jsmetric@nigel.in"]
  s.homepage    = ""
  s.summary     = %q{Cyclometric complexity analyser for Javascript}
  s.description = %q{Cyclometric complexity analyser for Javascript}

  s.rubyforge_project = "jsmetric"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('rspec', '2.4.0')
  s.add_dependency('rake', '0.8.7')
  s.add_dependency('cucumber', '0.10.0')
  s.add_dependency('therubyracer', '0.8.0')
end
