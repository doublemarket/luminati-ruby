# frozen_string_literal: true

RSpec.describe Luminati::Client do
  let(:api_token) { "thisismyapitoken" }

  before do
    @client = Luminati::Client.new(api_token)
  end

  describe "#initialize" do
    subject { @client }

    it "sets an instance variable of the given API token if it's provided" do
      expect(subject.instance_variable_get(:@api_token)).to eq(api_token)
    end
  end

  describe "#network_status" do
    let(:expected_status) { 200 }
    let(:expected_body) { "{\"status\"=>true}" }

    before do
      stub_request(:get, "#{Luminati::Client::API_URL}/api/network_status/#{network_type}")
        .to_return(status: expected_status, body: expected_body)
    end

    describe "when it gets a valid network_type" do
      let(:network_type) { :all }

      it "sends a request to a correct endpoint" do
        @client.network_status
        expect(a_request(:get, "#{Luminati::Client::API_URL}/api/network_status/#{network_type}")).to have_been_made
      end

      it "returns the status" do
        response = @client.network_status(network_type)
        expect(response["status"]).to be_truthy
      end
    end

    describe "when it gets an invalid network_type" do
      let(:network_type) { :somethinginvalid }
      let(:expected_status) { 400 }
      let(:expected_body) { "Invalid network type" }

      it "returns an error" do
        response = @client.network_status(network_type)
        expect(response["status_code"]).to eq(400)
        expect(response["response_body"]).to eq("Invalid network type")
      end
    end
  end

  describe "#cities" do
    let(:country_code) { :jp }
    let(:expected_status) { 200 }
    let(:expected_body) { fixture("get-api-cities-response.txt") }

    before do
      stub_request(:get, "#{Luminati::Client::API_URL}/api/cities?country=#{country_code}")
        .to_return(status: expected_status, body: expected_body)
    end

    describe "when it gets a valid country code" do
      it "sends a request to a correct endpoint" do
        @client.cities(country_code)
        expect(a_request(:get, "#{Luminati::Client::API_URL}/api/cities?country=#{country_code}")).to have_been_made
      end

      it "returns cities in the given country" do
        response = @client.cities(country_code)
        expect(response[0]).to_not be_empty
      end
    end

    describe "when it gets an invalid country code" do
      let(:country_code) { :somethinginvalid }
      let(:expected_body) { "[]" }

      it "returns an empty array" do
        response = @client.cities(country_code)
        expect(response).to be_an Array
        expect(response.size).to eq(0)
      end
    end
  end
end
