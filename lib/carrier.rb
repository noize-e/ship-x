module Carrier
    STATUS = ['CREATED',
              'ON_TRANSIT',
              'DELIVERED',
              'EXCEPTION']

    @@carriers = {}

    def self.register class_name, &class_ref
        @@carriers[class_name] = Class.new do
            instance_eval(&class_ref)
        end
    end

    def self.connect carrier_name, config
        @@config = config
        @@carrier = @@carriers[carrier_name].connect(config['auth'])
    end

    def self.track(code)
        result = @@carrier.track(code)
        codes = @@config['shipping']['status_codes']

        status = STATUS[codes[result[:status_code]]]

        if not result[:exception].nil?
            status = STATUS[3]
        end

        {:status => status}
    end
end