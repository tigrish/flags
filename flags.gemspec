# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "flags/version"

Gem::Specification.new do |s|
  s.name        = "flags"
  s.version     = Flags::VERSION
  s.authors     = ["Christopher Dell"]
  s.email       = ["chris@tigrish.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "flags"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "rmagick"
  s.add_runtime_dependency "slop"
end
