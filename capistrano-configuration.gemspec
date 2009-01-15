# Gem::Specification for capistrano-configuration

Gem::Specification.new do |s|
  s.name              = "capistrano-configuration"
  s.version           = "0.1.2"
  s.date              = "2009-01-12"
  s.author            = "Kieran Pilkington"
  s.email             = "kieran@katipo.co.nz"
  s.homepage          = "http://github.com/kete/capistrano-configuration"
  s.summary           = "Configure your application on deployment"
  s.description       = "Write application configuration files on deployment with Ruby"
  s.require_path      = "lib"
  s.files             = %w{ capistrano-configuration.gemspec
                            CHANGELOG.rdoc
                            install.rb
                            lib/capistrano-configuration.rb
                            Manifest
                            MIT-LICENSE
                            Rakefile
                            README.rdoc }
  s.has_rdoc          = true
  s.extra_rdoc_files  = %w{ CHANGELOG.rdoc
                            MIT-LICENSE
                            README.rdoc }
  s.rdoc_options      = ["--line-numbers",
                         "--inline-source",
                         "--title",
                         "capistrano-configuration",
                         "--main",
                         "README.rdoc"]
  s.rubygems_version  = "1.1.1"
  s.add_dependency      "capistrano", ">= 1.1.0"
  s.rubyforge_project = "capistrano-conf"
end
