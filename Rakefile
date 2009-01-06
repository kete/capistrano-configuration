namespace :gem do

  task :default => :build

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
    sh "sudo gem install --local #{gem_filename}"
  end

end

task :default => ['gem:build', 'gem:install']
