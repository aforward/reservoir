# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "reservoir/version"

Gem::Specification.new do |s|
  s.name        = "reservoir"
  s.version     = Reservoir::VERSION
  s.authors     = ["Andrew Forward"]
  s.email       = ["aforward@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{What apps, versions and configurations to you have setup on your server}
  s.description = %q{Helps manage cloud-based server instances by enumerating, comparing and diff'ing application configurations}

  s.rubyforge_project = "reservoir"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.default_executable = 'bin/reservoir'
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
