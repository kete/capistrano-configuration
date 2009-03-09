require 'test/unit'

# Mock Capistrano modules/methods.
# We don't need to test them (capistrano does that)
module Capistrano
  class Configuration
    def self.instance; self; end
    def self.load(&block); end
  end
end

require File.dirname(__FILE__) + "/../lib/capistrano-configuration"

class CapistranoConfigurationTest < Test::Unit::TestCase

  include CapistranoConfiguration

  def setup
    @@current_config = nil
    @@configurations = Hash.new
    @@locations = Hash.new
    @@current_envs = Array.new
    @@original_envs = Array.new
  end

  def test_configure_cannot_be_used_within_itself
    assert_raise CapistranoConfigurationError do
      configure :test do
        configure :this
      end
    end
  end

  def test_environment_cannot_be_used_on_its_own
    assert_raise CapistranoConfigurationError do
      environment :test
    end
  end

  def test_config_cannot_be_used_on_its_own
    assert_raise CapistranoConfigurationError do
      config :key, :value
    end
  end

  def test_configure_requires_a_block
    assert_raise CapistranoConfigurationError do
      configure :test
    end
  end

  def test_environment_requires_a_block
    assert_raise CapistranoConfigurationError do
      configure :test do
        environment :test
      end
    end
  end

  def test_configure_stores_correct_settings
    configure :test do
      assert_equal :test, @@current_config
    end
    assert_equal({ :test => {} }, @@configurations)
    assert_equal nil, @@current_config
  end

  def test_configure_stores_symbols
    configure 'test' do
      assert_equal :test, @@current_config
    end
  end

  def test_config_within_an_configure
    configure :test do
      config 'key', 'value'
    end
    assert_equal({ :test => { 'key' => 'value' } }, @@configurations)
  end

  def test_config_within_an_environment_within_an_configure
    configure :test do
      environment :test do
        config 'key', 'value'
      end
    end
    assert_equal({ :test => { :test => { 'key' => 'value' } } }, @@configurations)
  end

  def test_config_within_two_environments_within_an_configure
    configure :test do
      environment :test do
        environment :test do
          config 'key', 'value'
        end
      end
    end
    assert_equal({ :test => { :test => { :test => { 'key' => 'value' } } } }, @@configurations)
  end

  def test_config_within_different_environments_within_a_configure
    configure :test do
      environment :test1 do
        config 'key', 'value'
      end
      environment :test2 do
        config 'key', 'value'
      end
    end
    assert_equal({ :test => { :test1 => { 'key' => 'value' },
                              :test2 => { 'key' => 'value' } } }, @@configurations)
  end

  def test_config_within_different_environments_within_an_environment_within_an_configure
    configure :test do
      environment :test1 do
        environment :test2 do
          config 'key', 'value'
        end
        environment :test3 do
          config 'key', 'value'
        end
      end
    end
    assert_equal({ :test => { :test1 => { :test2 => { 'key' => 'value' },
                                          :test3 => { 'key' => 'value' } } } }, @@configurations)
  end

  def test_complex_nesting_with_multiple_environments_and_configurations
    configure :test do
      environment :test1 do
        environment :test2 do
          config 'key', 'value'
          environment :test3 do
            config 'key', 'value'
            environment :test4 do
              config 'key', 'value'
            end
            environment :test5 do
              config 'key', 'value'
              environment :test6 do
                config 'key', 'value'
              end
            end
          end
        end
        environment :test7 do
          config 'key', 'value'
        end
      end
    end
    assert_equal({
      :test => {
        :test1 => {
          :test2 => {
            "key"=>"value",
            :test3 => {
              "key"=>"value",
              :test4 => { "key"=>"value" },
              :test5 => {
                "key"=>"value",
                :test6 => { "key"=>"value" }
              }
            }
          },
          :test7 => { "key"=>"value" }
        }
      }
    }, @@configurations)
  end

  def test_normal_usage_of_capistrano_configuration
    configure :database do
      environment 'development' do
        config 'adapter', 'mysql'
        config 'database', 'test'
        config 'username', 'test'
        config 'password', 'test'
        config 'host', 'localhost'
      end
      environment 'production' do
        config 'adapter', 'mysql'
        config 'database', 'test'
        config 'username', 'test'
        config 'password', 'test'
        config 'host', 'localhost'
      end
      environment 'test' do
        config 'adapter', 'mysql'
        config 'database', 'test'
        config 'username', 'test'
        config 'password', 'test'
        config 'host', 'localhost'
      end
    end
    configure :backgroundrb do
      context :backgroundrb do
        config :port, 5000
        config :ip, '127.0.0.1'
        config :environment, 'production'
        config :result_storage, 'memcache'
        config :persistent_disabled, true
      end
      config :memcache, "127.0.0.1:11211"
    end
    configure :google_map_api do
      context :google_map_api do
        config :api_key, 'google-key'
        config :default_latitude, 1.2345
        config :default_longitude, 1.2345
        config :default_zoom_lvl, 2
      end
    end
    configure :site_lockdown_auth_credentials do
      config 'username', 'username'
      config 'password', 'password'
    end

    assert_equal({
      :database => {
        "development" => {
          "username"=>"test",
          "adapter"=>"mysql",
          "host"=>"localhost",
          "password"=>"test",
          "database"=>"test"
        },
        "test" => {
          "username"=>"test",
          "adapter"=>"mysql",
          "host"=>"localhost",
          "password"=>"test",
          "database"=>"test"
        },
        "production" => {
          "username"=>"test",
          "adapter"=>"mysql",
          "host"=>"localhost",
          "password"=>"test",
          "database"=>"test"
        }
      },
      :backgroundrb => {
        :backgroundrb => {
          :port=>5000,
          :ip=>"127.0.0.1",
          :result_storage=>"memcache",
          :persistent_disabled=>true,
          :environment=>"production"
        },
        :memcache=>"127.0.0.1:11211"
      },
      :google_map_api => {
        :google_map_api => {
          :api_key=>"google-key",
          :default_latitude=>1.2345,
          :default_longitude=>1.2345,
          :default_zoom_lvl=>2
        }
      },
      :site_lockdown_auth_credentials => {
        "username" => "username",
        "password" => "password"
      }
    }, @@configurations)
  end

  def test_file_path_for
    configure :test1 do; end
    configure :test2, :to_file => '/etc/configs/test2.yml' do; end
    configure :test3, :to_file => '/etc/configs/test3.yml' do; end

    assert_equal "./test1.yml", file_path_for(:test1)
    assert_equal "/etc/configs/test1.yml", file_path_for(:test1, '/etc/configs')
    assert_equal "/etc/configs/test2.yml", file_path_for(:test2)
    assert_equal "/etc/configs/test3.yml", file_path_for(:test3)
  end

end
