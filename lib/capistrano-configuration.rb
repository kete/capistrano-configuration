unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano-configuration requires Capistrano 2"
end

module CapistranoConfiguration
  unless included_modules.include? CapistranoConfiguration

    @@configurations = Hash.new
    @@current_config = String.new
    @@current_env = String.new

    def configure(config)
      @@current_config = config
      @@configurations[@@current_config] ||= Hash.new
      yield
    end

    def environment(env)
      @@current_env = env
      @@configurations[@@current_config][@@current_env] ||= Hash.new
      yield
      @@current_env = nil
    end
    alias :context :environment

    def config(setting, value)
      if @@current_env.nil?
        @@configurations[@@current_config][setting] = value
      else
        @@configurations[@@current_config][@@current_env][setting] = value
      end
    end

    Capistrano::Configuration.instance.load do

      namespace :deploy do

        namespace :configuration do

          desc 'Write the configuration files based on whats in @@configurations'
          task :write, :role => :app do
            abort "@@configurations is empty. Did you forget to define some configurations?" if @@configurations.empty?
            @@configurations.each do |file, value|
              run "cd #{current_path} && rm -rf config/#{file}.yml"
              run "cd #{current_path} && echo '#{value.to_yaml.gsub("'", "\\'")}' >> config/#{file}.yml"
            end
          end

        end

      end
      
      after "deploy:update_code", "deploy:configuration:write"

    end

  end
end

Capistrano::Configuration.send(:include, CapistranoConfiguration)
