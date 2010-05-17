# -*- encoding: utf-8 -*-

require File.expand_path("../lib/wol/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "wol"
  s.version     = Wol::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matias Korhonen"]
  s.email       = ["me@matiaskorhonen.fi"]
  s.homepage    = "http://wol.matiaskorhonen.fi"
  s.summary     = "Ruby Wake-On-LAN"
  s.description = "Send Wake-On-LAN magic packets from Ruby or from CLI"

  s.required_rubygems_version = ">= 1.3.6"
  
  s.rubyforge_project         = "wol"

  # Files that aren't .rb files
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "COPYING", "*.rdoc"]
  s.require_path = 'lib'

  # If you need an executable, add it here
  s.executables = ["wol"]

  # If you have C extensions, uncomment this line
  # s.extensions = "ext/extconf.rb"
end