# frozen_string_literal: true

module Luminati
  class Client
    module Zone
      module Ips
        # Returns datacenter IPs for a given zone.
        # @see https://luminati.io/doc/api#account_api_zone_datacenter_ips
        # @param zone_name [String]
        # @param ip_per_country [Boolean] `true` when you want to get a total amount of IPs per country
        # @return [Hash]
        def zone_ips(zone_name, ip_per_country = false)
          parameters = "zone=#{zone_name}"
          parameters << "&ip_per_country" if ip_per_country
          request(:get, "/api/zone/ips?#{parameters}")
        end

        # Returns zones and IPs with connectivity issues.
        # @see https://luminati.io/doc/api#allocated_unavailable_ips
        # @return [Hash] When there's no zones that has issues, this should be `{}`.
        def unavailable_zones_ips
          request(:get, "/api/zone/ips/unavailable")
        end

        # Add IPs to a given zone
        # @see https://luminati.io/doc/api#account_api_add_ips
        # @param ip_info [Hash]
        # @return [Hash] Added IPs information
        def add_ips(ip_info)
          data = ip_info
          request(:post, "/api/zone/ips", Oj.dump(data, mode: :compat))
        end

        # Remove Ips from a given zone
        # @see https://luminati.io/doc/api#account_api_remove_ips
        # @param zone_name [String]
        # @param ips [Array] An array of IPs
        # @return [Hash]
        def remove_ips(zone_name, ips)
          data = {}
          data["zone"] = zone_name
          data["ips"] = ips
          request(:delete, "/api/zone/ips", Oj.dump(data, mode: :compat))
        end
      end
    end
  end
end
