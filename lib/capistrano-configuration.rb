unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano-configuration requires Capistrano 2"
end

module CapistranoConfiguration
  unless included_modules.include? CapistranoConfiguration

    class CapistranoConfigurationError < Exception; end

    @@current_config = nil
    @@configurations = Hash.new
    @@locations = Hash.new
    @@current_envs = Array.new
    @@original_envs = Array.new

    def configure(config, options={})
      raise CapistranoConfigurationError.new("You cannot call configure without first closing an already existing configure.") unless @@current_config.nil?
      raise CapistranoConfigurationError.new("Configure is designed to work with a block. Please pass it one.") unless block_given?
      @@current_config = config.to_sym
      @@configurations[@@current_config] ||= Hash.new
      @@locations[@@current_config] = options[:to_file] if options[:to_file]
      yield
      @@current_config = nil
    end

    def environment(env)
      raise CapistranoConfigurationError.new("You cannot call environment without wrapping it inside a configure call.") if @@current_config.nil?
      raise CapistranoConfigurationError.new("Environment is designed to work with a block. Please pass it one.") unless block_given?
      current_level[env] ||= Hash.new
      @@original_envs << @@current_envs.dup
      @@current_envs << env
      yield
      @@current_envs = @@original_envs.pop
    end
    alias :context :environment

    def config(setting, value)
      raise CapistranoConfigurationError.new("You cannot call config without wrapping it inside a configure or environment call.") if @@current_config.nil?
      current_level[setting] = value
    end

    def file_path_for(configuration, default='.')
      if @@locations[configuration.to_sym]
        @@locations[configuration.to_sym]
      else
        "#{default}/#{configuration}.yml"
      end
    end

    Capistrano::Configuration.instance.load do

      namespace :deploy do

        namespace :configuration do

          desc 'Write the configuration files based on whats in @@configurations'
          task :write, :role => :app do
            abort "@@configurations is empty. Did you forget to define some configurations?" if @@configurations.empty?
            @@configurations.each do |configuration, value|
              file_path = file_path_for(configuration, "#{current_path}/config")
              run "cd #{current_path} && rm -rf #{file_path}"
              put value.to_yaml, file_path
            end
          end

        end

      end

      after "deploy:symlink", "deploy:configuration:write"

    end

    private

    def current_level
      env_string = @@current_envs.collect { |env| env.is_a?(String) ? "['#{env}']" : "[:#{env}]" }.join('')
      eval("@@configurations[@@current_config]#{env_string}")
    end

  end
end

Capistrano::Configuration.send(:include, CapistranoConfiguration)
