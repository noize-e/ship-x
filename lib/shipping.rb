require_relative "command"
require_relative "carrier"
require 'yaml'


module Shipment
    def self.track(carrier)
        command = Command.new

        # load carrier settings
        command.add params: {:carrier => carrier} do |params|
            # load custom carrier settings from yaml file
            config_path = "./config/carriers/#{params[:carrier]}.yml"
            {
                :carrier => carrier,
                :config => YAML.load(File.open(config_path).read)
            }
        end

        # Create carrier instance
        command.add do |params|
            # create from the given carrier name a new Carrier instance
            carrier_name = params[:carrier]
            require "./lib/carriers/#{carrier_name}"
            {
                :carrier => Carrier.create(carrier_name, params[:config])
            }
        end

        command
    end
end



