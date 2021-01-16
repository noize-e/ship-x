require_relative 'lib/shipping'

carrier = 'Fedex'

Shipping::Status::track(carrier)