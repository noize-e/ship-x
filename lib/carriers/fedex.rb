require './lib/carrier'
require 'fedex'

DEBUG = true


Carrier.register 'fedex' do
    def connect creds
        # connect to Fedex API
        @fedex = Fedex::Shipment.new(
            :key => creds['key'],
            :password => creds['password'],
            :account_number => creds['account_number'],
            :meter => creds['meter'],
            :mode => creds['mode'])

        # return the instance for later reference
        return self
    end

    def track code
        begin
            results = @fedex.track(:tracking_number => code)
            tracking_info = results.first

            if DEBUG
                puts "Shipment tracking info"
                puts %Q{
                    Tracking number: #{tracking_info.tracking_number}"
                    Event:
                      Status: #{tracking_info.status} (#{tracking_info.events.first.description})
                      Status Code: #{tracking_info.status_code}
                      Ocurred at: #{tracking_info.events.first.occurred_at}
                      Locale: #{tracking_info.events.first.country}, #{tracking_info.events.first.postal_code}
                    Exception:
                      Code: #{tracking_info.events.first.exception_code}
                      Description: #{tracking_info.events.first.exception_description}
                    Request:
                      Message: #{tracking_info.details[:notification][:message]}
                      Code: #{tracking_info.details[:notification][:code]}
                }
            end

            {
                :status_code => tracking_info.status_code,
                :exception => tracking_info.events.first.exception_code
            }
        rescue Fedex::RateError => e
            {
                :status_code => "Not Found",
                :exception => "Rate Error"
            }
        end
    end
end