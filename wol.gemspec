# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("../lib", __FILE__)
require "wol/version"

Gem::Specification.new do |gem|
  gem.authors     = ["Matias Korhonen"]
  gem.email       = ["me@matiaskorhonen.fi"]
  gem.homepage    = "http://github.com/k33l0r/wol"
  gem.summary     = "Ruby Wake-On-LAN"
  gem.description = "Send Wake-On-LAN magic packets from Ruby or from CLI"

  gem.name          = "wol"
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]
  gem.version       = Wol::VERSION

  gem.add_development_dependency "rake"
  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rspec", "~> 2.9.0"
end
