# frozen_string_literal: true

RSpec.describe Luminati::Client::Customer do
  let(:api_token) { "thisismyapitoken" }

  before do
    @client = Luminati::Client.new(api_token)
  end

  describe "#customer_bandwidth_stats" do
    before do
      stub_request(:get, "#{Luminati::Client::API_URL}/api/customer/bw?details=1")
        .to_return(body: fixture("get-api-customer-bw-response.json"))
    end

    it "sends a request to a correct endpoint" do
      @client.customer_bandwidth_stats
      expect(a_request(:get, "#{Luminati::Client::API_URL}/api/customer/bw?details=1")).to have_been_made
    end

    it "returns stats" do
      response = @client.customer_bandwidth_stats
      expect(response["thisisasample"]["mobile"]).to_not be_empty
      expect(response["thisisasample"]["residential"]).to_not be_empty
      expect(response["thisisasample"]["static_res"]).to_not be_empty
    end
  end

  describe "#customer_balance" do
    before do
      stub_request(:get, "#{Luminati::Client::API_URL}/api/customer/balance")
        .to_return(body: "{\"balance\"=>6, \"balance_real\"=>1, \"balance_bonus\"=>5, \"pending_costs\"=>0")
    end

    it "sends a request to a correct endpoint" do
      @client.customer_balance
      expect(a_request(:get, "#{Luminati::Client::API_URL}/api/customer/balance")).to have_been_made
    end

    it "returns balance" do
      response = @client.customer_balance
      expect(response["balance"]).to_not be_empty
      expect(response["balance_real"]).to_not be_empty
      expect(response["balance_bonus"]).to_not be_empty
      expect(response["pending_costs"]).to_not be_empty
    end
  end
end
