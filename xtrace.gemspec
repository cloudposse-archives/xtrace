# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "xtrace/version"

Gem::Specification.new do |s|
  s.name        = "xtrace"
  s.version     = XTrace::VERSION
  s.authors     = ["Erik Osterman"]
  s.email       = ["e@osterman.com"]
  s.homepage    = "https://github.com/osterman/xtrace"
  s.summary     = %q{XTrace is a gem to evaluate .xt trace files generated by the XDebug PHP extension}
  s.description = %q{XTrace is a gem to evaluate .xt trace files generated by the XDebug PHP extension}

  s.rubyforge_project = "xtrace"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  #s.add_runtime_dependency "iconv"
end
