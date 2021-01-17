require_relative "command"
require_relative "carrier"
require 'yaml'


module Shipment
    def self.track(carrier, code)
        command = Command.new

        # load carrier settings
        command.add params: {:carrier_name => carrier} do |params|
            # load custom carrier settings from yaml file
            config_path = "./config/carriers/#{params[:carrier_name]}.yml"
            {:config => YAML.load(File.open(config_path).read)}
        end

        # Register and connect to carrier's api
        command.add do |params|
            require "./lib/carriers/#{params[:carrier_name]}"
            # connect to carrier's api
            Carrier.connect(params[:carrier_name], params[:config])
        end

        # Track shipment
        command.add params: {:code => code} do |params|
            # Track the shipment with a tracking number
            puts Carrier.track(params[:code])
        end

        command
    end
end



