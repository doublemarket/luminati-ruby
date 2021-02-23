# frozen_string_literal: true

require "luminati/client/zone"
require "luminati/client/zone/ips"
require "luminati/client/customer"

module Luminati
  class Client
    include Luminati::Client::Zone
    include Luminati::Client::Zone::Ips
    include Luminati::Client::Customer

    API_URL = "https://luminati.io"

    attr_accessor :api_token

    # Initializes a new Client object.
    # @param api_token [String]
    # @return [Luminati::Client]
    def initialize(api_token = nil)
      instance_variable_set("@api_token", api_token) if api_token
    end

    # Returns the current service status for a given network type
    # @see https://luminati.io/doc/api#account_api_stat
    # @param network_type [Symbol] A network type, one of `:all`, `:res`, `:dc`, `:mobile`.
    # @return [Hash]
    def network_status(network_type = :all)
      request(:get, "/api/network_status/#{network_type}")
    end

    # Returns cities for a given country
    # @see https://luminati.io/doc/api#others_get_cities
    # @param country_code [String] A country code like `US`.
    # @return [Hash]
    def cities(country_code)
      request(:get, "/api/cities?country=#{country_code}")
    end

    private

    def conn
      headers = {
        "Content-Type": "application/json"
      }
      headers = headers.merge({ "Authorization": "Bearer #{@api_token}" }) if @api_token
      @conn ||= Faraday.new(
        API_URL,
        request: { timeout: 5 },
        headers: headers
      )
    end

    def request(method, path, options = nil)
      res = if method == :delete
              conn.delete(path) { |req| req.body = options }
            else
              conn.public_send(method, path, options)
            end
      if res.status == 200
        begin
          Oj.load(res.body)
        rescue Oj::ParseError
          # when the body isn't JSON (e.g. GET /api/zone/route_ips)
          res.body
        end
      else
        { "status_code" => res.status, "status_message" => res.reason_phrase, "response_body" => res.body }
      end
    end
  end
end
