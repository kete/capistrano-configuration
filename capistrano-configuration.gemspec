# Gem::Specification for capistrano-configuration

Gem::Specification.new do |s|
  s.name              = "capistrano-configuration"
  s.version           = "0.2.1"
  s.date              = "2009-11-18"
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
                            README.rdoc
                            test/capistrano_configuration_test.rb }
  s.has_rdoc          = true
  s.extra_rdoc_files  = %w{ CHANGELOG.rdoc
                            MIT-LICENSE
                            README.rdoc }
  s.rdoc_options      = ["--line-numbers",
                         "--title",
                         "capistrano-configuration",
                         "--main",
                         "README.rdoc"]
  s.rubygems_version  = "1.3.0"
  s.add_dependency      "capistrano", ">= 2.0.0"
  s.rubyforge_project = "capistrano-conf"
end
