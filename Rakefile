require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

namespace :gem do

  task :default => ['gem:build', 'gem:install']

  desc 'Build the Capistrano Configuration Gem'
  task :build do
    Dir['*.gem'].each do |gem_filename|
      sh "rm -rf #{gem_filename}"
    end
    sh "gem build capistrano-configuration.gemspec"
  end

  desc 'Install the Capistrano Configuration Gem'
  task :install do
    gem_filename = Dir['*.gem'].first
    sh "sudo gem install #{gem_filename}"
  end

end

task :gem => ['gem:build', 'gem:install']

desc 'Test Capistrano Configuration Gem'
Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

task :default do
  puts "----"
  puts "              rake  -  This menu"
  puts "         rake test  -  Test the gem"
  puts "          rake gem  -  Build and install gem"
  puts "    rake gem:build  -  Build gem"
  puts "  rake gem:install  -  Install gem"
  puts "----"
end
