require "bundler"
Bundler.setup

require "rspec/core/rake_task"
Rspec::Core::RakeTask.new(:spec)

gemspec = eval(File.read("wol.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["wol.gemspec"] do
  system "gem build wol.gemspec"
  system "gem install wol-#{Wol::VERSION}.gem"
end
