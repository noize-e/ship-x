require_relative 'lib/shipping'

carrier = 'fedex'
code = '449044304137821'


Shipment::track(carrier, code).execute