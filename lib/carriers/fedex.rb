require './lib/carrier'
require 'fedex'


Carrier.register 'fedex' do
    def connect config
        auth = config['auth']
        @fedex = Fedex::Shipment.new(
            :key => auth['key'],
            :password => auth['password'],
            :account_number => auth['account_number'],
            :meter => auth['meter'],
            :mode => auth['mode'])
        return self
    end

    def track code
        results = @fedex.track(:tracking_number => code)
        results.first
    end
end