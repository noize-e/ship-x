require_relative "command"
require_relative "carrier"
require 'yaml'


module Shipment
    def self.track(carrier, code)
        command = Command.new

        # load carrier settings
        command.add params: {:carrier => carrier} do |params|
            # load custom carrier settings from yaml file
            config_path = "./config/carriers/#{params[:carrier]}.yml"
            {
                :carrier_name => carrier,
                :config => YAML.load(File.open(config_path).read)
            }
        end

        # Create carrier instance
        command.add do |params|
            require "./lib/carriers/#{params[:carrier_name]}"
            # connect to carrier's api
            {:carrier => Carrier.connect(params[:carrier_name], params[:config])}
        end

        command.add params: {:code => code} do |params|
            # create from the given carrier name a new Carrier instance
            carrier = params[:carrier]
            puts carrier.track(params[:code])
        end

        command
    end
end



