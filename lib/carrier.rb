module Carrier
    STATUS = ['CREATED','ON_TRANSIT','DELIVERED', 'EXCEPTION']
    @@carriers = []

    def self.included(host_class)
        @@carriers << host_class
    end

    def self.create(carrier_name, config)
        carrier_class = @@carriers.find{|carrier| carrier.to_s.downcase == carrier_name.to_s.downcase}
        carrier_class.new(config)
    end
end