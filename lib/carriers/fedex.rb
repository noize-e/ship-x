require './lib/carrier'


class Fedex
    include Carrier

    def initialize(config)
        @config = config
    end
end