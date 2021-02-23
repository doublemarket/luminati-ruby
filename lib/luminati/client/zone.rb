# frozen_string_literal: true

module Luminati
  class Client
    module Zone
      # Returns the bandwidth stats for a given zone
      # @see https://luminati.io/doc/api#stats_api_bw_zone
      # @param zone_name [String]
      # @param from [String] This should be in the format `2018-07-01T00:00:00`.
      # @param to [String] This should be in the format `2018-07-02T00:00:00`.
      # @return [Hash]
      def zone_bandwidth_stats(zone_name, from = nil, to = nil)
        parameters = "zone=#{zone_name}&details=1"
        parameters << "&from=#{from}" if from
        parameters << "&to=#{to}" if to
        request(:get, "/api/zone/bw?#{parameters}")
      end

      # Returns the cost and the bandwidth stats for a given zone
      # @see https://luminati.io/doc/api#stats_api_cost_zone
      # @param zone_name [String]
      # @param from [String] This should be in the format `2018-07-01T00:00:00`.
      # @param to [String] This should be in the format `2018-07-02T00:00:00`.
      # @return [Hash]
      def zone_cost_stats(zone_name, from = nil, to = nil)
        parameters = "zone=#{zone_name}"
        parameters << "&from=#{from}" if from
        parameters << "&to=#{to}" if to
        request(:get, "/api/zone/cost?#{parameters}")
      end

      # Returns the number of available IPs
      # @see https://luminati.io/doc/api#account_api_count_available_ips
      # @param zone_name [String]
      # @param plan [Hash]
      # @return [Hash]
      def zone_available_ip_count(zone_name, plan = nil)
        parameters = "zone=#{zone_name}"
        parameters << "&plan=#{Oj.dump(plan, mode: :compat)}" if plan
        request(:get, "/api/zone/count_available_ips?#{parameters}")
      end

      # Returns recent IPs attempting to use a given zone
      # @see https://luminati.io/doc/api#ip_mgmnt_api_ip_attempt
      # @param zone_names [String] `*` or zone names separated with `,`
      # @return [Hash]
      def zone_recent_ips(zone_names)
        parameters = "zones=#{zone_names}"
        request(:get, "/api/zone/recent_ips?#{parameters}")
      end

      # Returns avaialble IPs in a given zone and a given country
      # @see https://luminati.io/doc/api#ip_mgmnt_ips_country_dc
      # @param zone_name [String]
      # @param country_code [String] A country code like `US`.
      # @param expand [Boolean] `true` when you want expanded IPs
      # @return [Hash]
      def zone_available_ips(zone_name, country_code = nil, expand = false)
        parameters = "zone=#{zone_name}"
        parameters << "&country=#{country_code}" if country_code
        parameters << "&expand=1" if expand
        request(:get, "/api/zone/route_ips?#{parameters}")
      end

      # Returns available VIPs in a given zone
      # @see https://luminati.io/doc/api#ip_mgmnt_gips
      # @param zone_name [String]
      # @return [Hash]
      def zone_available_vips(zone_name)
        parameters = "zone=#{zone_name}"
        request(:get, "/api/zone/route_vips?#{parameters}")
      end

      # Returns the information of a given zone
      # @see https://luminati.io/doc/api#account_api_get_zone
      # @param zone_name [String]
      # @return [Hash]
      def zone_info(zone_name)
        parameters = "zone=#{zone_name}"
        request(:get, "/api/zone?#{parameters}")
      end

      # Adds a zone
      # @see https://luminati.io/doc/api#account_api_add_zone
      # @param zone_info [Hash]
      # @param plan_info [Hash]
      # @return [String] The official API documentation says it returns the information of the added zone but currently it returns just `OK`.
      def add_zone(zone_info, plan_info)
        data = {}
        data["zone"] = zone_info unless zone_info.empty?
        data["plan"] = plan_info unless plan_info.empty?
        request(:post, "/api/zone", Oj.dump(data, mode: :compat))
      end

      # Remove a zone
      # @see https://luminati.io/doc/api#account_api_remove_zone
      # @param zone_name [String]
      # @return [String] The official API documentation says it returns the information of the added zone but currently it returns just `OK`.
      def remove_zone(zone_name)
        data = {}
        data["zone"] = zone_name
        request(:delete, "/api/zone", Oj.dump(data, mode: :compat))
      end

      # Returns passwords of a given zone
      # @see https://luminati.io/doc/api#account_api_zone_passwords
      # @param zone_name [String]
      # @returns [Hash]
      def zone_passwords(zone_name)
        parameters = "zone=#{zone_name}"
        request(:get, "/api/zone/passwords?#{parameters}")
      end

      # Returns permissions of a given zone
      # @see https://luminati.io/doc/api#account_api_zone_perms
      # @param zone_name [String]
      # @returns [Hash]
      def zone_permissions(zone_name)
        parameters = "zone=#{zone_name}"
        request(:get, "/api/zone/permissions?#{parameters}")
      end

      # Returns the status of a given zone
      # @see https://luminati.io/doc/api#account_api_zone_status
      # @param zone_name [String]
      # @returns [Hash]
      def zone_status(zone_name)
        parameters = "zone=#{zone_name}"
        request(:get, "/api/zone/status?#{parameters}")
      end

      # Returns active zones
      # @see https://luminati.io/doc/api#account_api_get_active_zones
      # @returns [Hash]
      def active_zones
        request(:get, "/api/zone/get_active_zones")
      end
    end
  end
end
