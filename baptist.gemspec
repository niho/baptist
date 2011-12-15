# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "baptist/version"

Gem::Specification.new do |s|
  s.name        = "baptist"
  s.version     = Baptist::VERSION
  s.authors     = ["Niklas Holmgren"]
  s.email       = ["niklas@sutajio.se"]
  s.homepage    = "https://github.com/sutajio/baptist"
  s.summary     = %q{A tool for generating unique and well-formed URIs.}
  s.description = %q{Baptist creates well-formed relative URIs from a set of strings.}

  s.rubyforge_project = "baptist"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
