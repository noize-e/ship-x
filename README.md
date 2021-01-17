# ShipX - A Ruby Shipping API

ShipX is shipping API that connects you with multiple shipping carriers (such as Fedex, among others) through one interface.

## 1. Features

- An asynchronous HTTP server.
- Custom carrier API adapter.
- Fedex API pre-configurated.

## 2. Usage

Run Bundler to install gems dependencies:

```bash
$ bundle install
```

### 2.1 New Carrier Configuration

__Breakdown__

1. Create a YAML file with the carrier's API settings
2. Create the carriers adapter.

#### 2.1.1 Config

- File path: __`config/carriers/{custom_carrier}.yaml`__

```yaml
auth:
  key: "VZ0t..."
  password: "AKOh8...."
  account_number: "8023...."
  meter: "1004...."
  mode: "test"
shipping:
  status_codes:
    OC: 0
    ...
```

#### 2.1.2 Adapter

In a new file located at __`lib/carriers/{custom_carrier}.rb`__, register a custom carrier importing the module __`Carrier`__ located at __`lib/carrier.rb`__, then call the __`register`__ method, which receives 2 parameters:

1. __`class_name`__ _(`String`)_: the custom carrier name.
2. __`class_ref`__ _(`Proc`)_: A Proc object with 2 methods defined inside it's context:

    2.1. __`connect`__: Here add the custom carrier's API connection functionality.
        - param: __`creds`__ (_`Hash`_): Hash reference from carrier configuration setting __`auth`__.

    2.2. __`track`__: Here add the custom carrier's API tracking functionality.
        - param: __`code`__ (_`String`_): Tracking code reference.

> __Note!__ Do not forget to import the custom carrier's gem.


```ruby
require './lib/carrier'
# require 'custom carrier's gem'


Carrier.register 'custom_carrier' do

  # @param [Hash] creds
  def connect creds
    # connect to carrier's API
    @custom_carrier = Carrier::Shipment.new(...)
    return self
  end

  # @param [String] code
  def track code
    begin
      tracking_info = @custom_carrier.track(code)

      {
        :status_code => tracking_info.status_code,
        :exception => tracking_info.exception_code
      }
    rescue Carrier::Exception => e
      {
        :status_code => "Not Found",
        :exception => "Rate Error"
      }
    end
  end

end
```
