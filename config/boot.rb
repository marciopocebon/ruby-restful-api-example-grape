require 'bundler/setup'
require 'yaml'

# defines our constants
APP_ROOT = File.expand_path('../..', __FILE__) unless defined?(APP_ROOT)
RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)

# loads our dependencies
Bundler.require(:default, RACK_ENV)

# loads our configurarion
APP_CONFIG = YAML.load_file(File.join(__dir__, 'default.yml'))[RACK_ENV]

# connects to database
Grape::ActiveRecord.configure_from_file! APP_CONFIG['db']['location']

# configures logging
require_relative 'logging'

# loads all files needed from our app
dirs_to_load = APP_CONFIG['boot']['scan']['directories']

dirs_to_load.each do |directory|
  expression = "#{APP_ROOT}/#{directory}/*.rb"
  Dir[expression].each do |file|
    require file
  end
end
