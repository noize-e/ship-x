require_relative 'lib/shipping'

carrier = 'fedex'
code = '449044304137821'


response = Shipment::track(carrier, code).execute
puts response.data