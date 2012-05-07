root_path = File.dirname(__FILE__)

require 'yaml'
require "#{root_path}/helpers/path_helper.rb"
require "#{root_path}/configurators/abstract_configurator.rb"
require "#{root_path}/builders/abstract_builder.rb"
require "#{root_path}/setup_creator.rb"

class SetupManager
  attr_accessor :max_threads
  attr_accessor :config 

  IN_PROGRESS_STATUS = 'in_progress'
  READY_STATUS = 'ready'
  AWAITING_STATUS = 'awaiting'
  ERROR_STATUS = 'error'
  
  def load_config
    config_path = File.dirname(__FILE__) + "/config/config.yml";
    self.config = YAML::load(File.new(config_path)) 
    
    config['apps'].each do |name, options|
      builder = "#{config['global']['builder_path']}/#{options['builder'].underscore}.rb"
      configurator = "#{config['global']['configurator_path']}/#{options['configurator'].underscore}.rb"

      require(builder)
      require(configurator)
    end
  end

  def initialize
    @logger = Rails.logger
    load_config
  end

  def fetch_tasks
    apps = Application.fetch_apps(config['global']['max_threads'])
    apps.each do |app|
      Thread.new do
        build_setup(app)           
      end
    end
  end

  def build_setup(app)
    info "Setup build started", app
    begin 
      app.status = IN_PROGRESS_STATUS
      app.save
      app_name = "desktop"
      app_config = config['apps'][app_name]
      builder = app_config['builder'].constantize.new
      configurator = app_config['configurator'].constantize.new

      options = app_config['options']
      builder.options = options
      configurator.options = options

      creator = SetupCreator.new
      creator.builder = builder
      creator.configurator = configurator
      creator.config = app_config

      creator.copy_template
      creator.configure_setup(
      {
        credentials: { 
          user_id: app.auth_token.user_id,
          username: 'test',
          auth_token: app.auth_token.token
        } 
      })
      
      info "Application configured", app

      app.setup_path = creator.build_setup

      info "Application built", app

      creator.clean

      if !app.setup_path.nil?
        app.status = READY_STATUS
      else
        app.status = ERROR_STATUS
      end

      app.save
    rescue 
      app.status = ERROR_STATUS
      app.save
    end  
    info "Task complete", app
  end

  private
  def info(msg, app)
    Rails.logger.info "[Build Service:Application Id:#{app.id}] > #{msg}"
  end
end
