#!/usr/bin/env ruby
# frozen_string_literal: true

require 'async'
require 'async/http/endpoint'
require 'async/http/server'
require_relative 'lib/shipping'


Async do |parent|
    endpoint = Async::HTTP::Endpoint.parse("http://localhost:9292")

    server = Async::HTTP::Server.for(endpoint) do |request|
        begin
            if request.path =~ /\/(.*)\/(.*)/
                carrier = $1
                code = $2
                puts %Q{Tracking Request\n\tCarrier: #{carrier}\n\tTracking Number: #{code}}
                response = Shipment::track(carrier, code).execute
                Protocol::HTTP::Response[200, [], ["status: #{response.data[:status]}"]]
                # Protocol::HTTP::Response[204, [], [""]]
            else
                Protocol::HTTP::Response[404, [], []]
            end
        rescue Exception => e
            Protocol::HTTP::Response[400, [], ["Bad Request"]]
        end
    end

    server.run
end
