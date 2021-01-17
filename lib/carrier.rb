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

    def self.connect carrier, config
        @@carriers[carrier].connect(config)
    end
end