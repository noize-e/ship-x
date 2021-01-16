require_relative "command"
require 'yaml'


module Shipping
    class Status
        def self.track(carrier)
            command = Command.new
            command.add params: {:carrier => carrier} do |params|
                # load custom carrier settings from yaml file
                config_path = "./config/carriers/#{params[:carrier]}.yml"
                {
                    :config => YAML.load(File.open(config_path).read)
                }
            end
            command.add do |params|
                # create a new Carrier instance
                puts params
            end
            command.execute
        end
    end
end



