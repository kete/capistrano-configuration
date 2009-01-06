# require 'rubygems'
require "rake/gempackagetask"
require 'rake/rdoctask'
require "rake/clean"
require 'spec'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

spec = Gem::Specification.new do |s|
  s.name              = "capistrano-configuration"
  s.version           = "0.1.0"
  s.date              = "2009-01-06"
  s.platform          = Gem::Platform::RUBY
  s.author            = "Kieran Pilkington"
  s.email             = "kieran@katipo.co.nz"
  s.homepage          = "http://github.com/kete/capistrano-configuration"
  s.summary           = "Configure your application on deployment"
  s.description       = "Write application configuration files on deployment with Ruby"
  s.require_path      = "lib"
  s.files             = %w{ capistrano-configuration.gemspec CHANGELOG.rdoc install.rb lib/capistrano-configuration.rb Manifest MIT-LICENSE Rakefile README.rdoc }
  s.has_rdoc          = true
  s.extra_rdoc_files  = %w{ CHANGELOG.rdoc MIT-LICENSE README.rdoc }
  s.rdoc_options      = ["--line-numbers", "--inline-source", "--title", "Capistrano-Configuration", "--main", "README.rdoc"]
  s.rubygems_version  = "1.1.1"
  s.add_dependency      "capistrano", ">= 1.1.0"
  s.rubyforge_project = "capistrano-configuration"
  s.specification_version = 2 if s.respond_to? :specification_version=
end

Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
end

desc 'Show information about the gem.'
task :debug_gem do
  puts spec.to_ruby
end

CLEAN.include ["pkg", "*.gem", "doc", "ri", "coverage"]

desc 'Install the package as a gem.'
task :install_gem => [:clean, :package] do
  gem_filename = Dir['pkg/*.gem'].first
  sh "sudo gem install --local #{gem_filename}"
end

task :default => :gem
