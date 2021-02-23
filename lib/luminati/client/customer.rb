# frozen_string_literal: true

module Luminati
  class Client
    module Customer
      # Returns the bandwidth stats for all your zones.
      # @see https://luminati.io/doc/api#stats_api_bw_cust
      # @param from [String] This should be in the format `2018-07-01T00:00:00`.
      # @param to [String] This should be in the format `2018-07-02T00:00:00`.
      # @return [Hash]
      def customer_bandwidth_stats(from = nil, to = nil)
        parameters = "details=1"
        parameters << "&from=#{from}" if from
        parameters << "&to=#{to}" if to
        request(:get, "/api/customer/bw?#{parameters}")
      end

      # Returns the total balance of your account.
      # @see https://luminati.io/doc/api#account_api_balance
      # @return [Hash]
      def customer_balance
        request(:get, "/api/customer/balance")
      end
    end
  end
end
