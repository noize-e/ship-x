# ShipX - A Ruby Shipping API

ShipX is shipping API that connects you with multiple shipping carriers (such as Fedex, among others) through one interface.

- [ShipX - A Ruby Shipping API](#shipx---a-ruby-shipping-api)
  * [1. Features](#1-features)
  * [2. Install](#2-install)
  * [3 Setup A New Carrier](#3-setup-a-new-carrier)
    + [__3.1 Breakdown__](#--31-breakdown--)
    + [__3.2 Config__](#--32-config--)
    + [__3.3 Adapter__](#--33-adapter--)

## 1. Features

- An asynchronous HTTP server.
- Custom carrier's API adapter interface.
- Fedex API pre-configurated.

## 2. Install

Run Bundler to install the Gems dependencies:

```bash
$ bundle install
```

## 3. Setup A New Carrier

### __3.1. Breakdown__

1. Define the custom carrier's API settings in a YAML file.
2. Register the custom carrier's adapter.

### __3.2. Config__

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

As it is shown in the previous example, the __`auth`__ setting expect the API's credentials and the __`shipping.status_codes`__ expect a __`key-value`__ code reference.

- The __`key`__ must be the carrier's status code reference.
- The __`value`__ must be an integer which reference to a pre-defined homologated status_code, the codes list is referenced below.

| __Int Ref__ | __Status__ |
|:------------|:-----------|
| 0           | CREATED    |
| 1           | ON_TRANSIT |
| 2           | DELIVERED  |
| 3           | EXCEPTION  |

### __3.3. Adapter__

In a new file located at __`lib/carriers/{custom_carrier}.rb`__, register a custom carrier importing the module __`Carrier`__ located at __`lib/carrier.rb`__, then call the __`register`__ method, which receives 2 parameters:

1. __`class_name`__ _(`String`)_: the custom carrier name.
2. __`class_ref`__ _(`Proc`)_: A Proc object with 2 methods defined inside it's context:

    2.1. __`connect`__: Here add the custom carrier's API connection functionality.

        - param: __`creds`__ (_`Hash`_): Hash reference from carrier configuration setting __`auth`__.

    2.2. __`track`__: Here add the custom carrier's API tracking functionality.

        - param: __`code`__ (_`String`_): Tracking code reference.

> __NOTE!__
> Do not forget to import the custom carrier's gem.


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

## Usage

To start the HTTP server execute:

```bash
$ ruby server.rb
```

To track a shipment perform a HTTP GET request to __`http://localhost:9292/{carrier_name}/{tracking_number}`__ URL. For example:

```bash
$ curl http://localhost:9292/fedex/449044304137821
```

The response should be:

```console
Status: CREATED
```

From the server side, it generates the following log:

```console
Tracking Request
        Carrier: fedex
        Tracking Number: 449044304137821
[debug] Tracking Info
          Tracking number: 449044304137821"
          Event:
          Status: Shipment information sent to FedEx (Shipment information sent to FedEx)
          Status Code: OC
          Ocurred at: 2013-12-30 13:24:00 -0500
          Locale: US, 471307761
          Exception:
          Code:
          Description:
          Request:
          Message: Request was successfully processed.
          Code: 0
```