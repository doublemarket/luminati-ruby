# frozen_string_literal: true

RSpec.describe Luminati::Client::Zone::Ips do
  let(:api_token) { "thisismyapitoken" }

  before do
    @client = Luminati::Client.new(api_token)
  end

  describe "#zone_ips" do
    let(:zone_name) { "existingzonename" }
    let(:ip_per_country) { false }
    let(:expected_status) { 200 }
    let(:expected_body) { "{\"ips\":[{\"ip\":\"xxx.xxx.xxx.xxx\",\"maxmind\":\"jp\",\"ext\":{}}]}" }

    before do
      stub_request(:get, "#{Luminati::Client::API_URL}/api/zone/ips?zone=#{zone_name}#{"&ip_per_country" if ip_per_country}")
        .to_return(status: expected_status, body: expected_body)
    end

    describe "when it gets a valid zone name" do
      it "sends a request to a correct endpoint" do
        @client.zone_ips(zone_name)
        expect(a_request(:get, "#{Luminati::Client::API_URL}/api/zone/ips?zone=#{zone_name}")).to have_been_made
      end

      it "returns IP addresses" do
        response = @client.zone_ips(zone_name)
        expect(response["ips"]).to_not be_empty
      end
    end

    describe "when it gets an invalid zone name" do
      let(:zone_name) { "somethinginvalid" }
      let(:expected_status) { 422 }
      let(:expected_body) { "Unknown zone" }

      it "returns an error" do
        response = @client.zone_ips(zone_name)
        expect(response["response_body"]).to eq(expected_body)
      end
    end

    describe "when the ip_per_country option is provided" do
      let(:ip_per_country) { true }
      let(:expected_body) { "{\"jp\":1}" }

      it "returns the number of IPs for countries" do
        response = @client.zone_ips(zone_name, ip_per_country)
        expect(response["jp"]).to be_an(Integer)
      end
    end
  end

  describe "#unavailable_zones_ips" do
    let(:expected_status) { 200 }
    let(:expected_body) { "{\"zone1\":[\"xxx.xxx.xxx.xxx\"]}" }
    before do
      stub_request(:get, "#{Luminati::Client::API_URL}/api/zone/ips/unavailable")
        .to_return(status: expected_status, body: expected_body)
    end

    it "sends a request to a correct endpoint" do
      @client.unavailable_zones_ips
      expect(a_request(:get, "#{Luminati::Client::API_URL}/api/zone/ips/unavailable")).to have_been_made
    end

    it "returns IP addresses" do
      response = @client.unavailable_zones_ips
      expect(response).to be_a Hash
    end
  end

  describe "#add_ips" do
    let(:count) { 1 }
    let(:customer) { "youraccountid" }
    let(:zone) { "existingzonename" }
    let(:country) { "us" }
    let(:ip_info) {
      {
        customer: customer,
        zone: zone,
        count: count,
        country: country
      }
    }
    let(:expected_status) { 200 }
    let(:expected_body) { fixture("post-api-zone-ips-response.txt") }

    before do
      stub_request(:post, "#{Luminati::Client::API_URL}/api/zone/ips")
        .with(body: ip_info)
        .to_return(status: expected_status, body: expected_body)
    end

    describe "when it gets a valid IP info" do
      it "sends a request to a correct endpoint" do
        @client.add_ips(ip_info)
        expect(a_request(:post, "#{Luminati::Client::API_URL}/api/zone/ips")).to have_been_made
      end

      it "returns the added IPs info" do
        response = @client.add_ips(ip_info)
        expect(response["ips"]).to_not be_empty
      end
    end

    describe "when it gets an invalid IP info" do
      let(:ip_info) { {} }
      let(:expected_status) { 400 }
      let(:expected_body) { "Missing zone parameter" }

      it "returns an error" do
        response = @client.add_ips(ip_info)
        expect(response["response_body"]).to eq(expected_body)
      end
    end
  end

  describe "#remove_ips" do
    let(:zone_name) { "existingzonename" }
    let(:ips) {
      [
        "xxx.xxx.xxx.xxx"
      ]
    }
    let(:expected_status) { 200 }
    let(:expected_body) { "{\"ips\":[\"xxx.xxx.xxx.xxx\"]}" }

    before do
      stub_request(:delete, "#{Luminati::Client::API_URL}/api/zone/ips")
        .with(body: { zone: zone_name, ips: ips })
        .to_return(status: expected_status, body: expected_body)
    end

    describe "when it gets a valid zone name and valid IPs" do
      it "sends a request to a correct endpoint" do
        @client.remove_ips(zone_name, ips)
        expect(a_request(:delete, "#{Luminati::Client::API_URL}/api/zone/ips")).to have_been_made
      end

      it "returns OK which indicates the zone is created" do
        response = @client.remove_ips(zone_name, ips)
        expect(response["ips"]).to_not be_empty
      end
    end

    describe "when it gets an invalid zone name" do
      let(:zone_name) { "somethinginvalid" }
      let(:expected_status) { 422 }
      let(:expected_body) { "Unkonwn zone" }

      it "returns an error" do
        response = @client.remove_ips(zone_name, ips)
        expect(response["response_body"]).to eq(expected_body)
      end
    end

    describe "when it gets an invalid IPs (IPs that don't exist)" do
      let(:ips) {
        [
          "xyz.xyz.xyz.xyz"
        ]
       }
      let(:expected_status) { 400 }
      let(:expected_body) { "Cannot remove IPs not allocated to you" }

      it "returns an error" do
        response = @client.remove_ips(zone_name, ips)
        expect(response["response_body"]).to eq(expected_body)
      end
    end
  end
end
