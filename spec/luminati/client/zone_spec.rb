# frozen_string_literal: true

RSpec.describe Luminati::Client::Zone do
  let(:api_token) { "thisismyapitoken" }

  before do
    @client = Luminati::Client.new(api_token)
  end

  describe "#add_zone" do
    let(:zone_info) do
      {
        name: "testzone"
      }
    end
    let(:plan_info) do
      {
        type: "static",
        ips_type: "dedicated",
        bandwidth: "payperusage",
        country: "jp",
        ips: 1
      }
    end
    let(:body) do
      {
        zone: zone_info,
        plan: plan_info
      }
    end
    let(:expected_status) { 200 }
    let(:expected_body) { "OK" }

    before do
      stub_request(:post, "#{Luminati::Client::API_URL}/api/zone")
        .with(body: body)
        .to_return(status: expected_status, body: expected_body)
    end

    describe "when it gets a valid zone info and a valid plan info" do
      it "sends a request to a correct endpoint" do
        @client.add_zone(zone_info, plan_info)
        expect(a_request(:post, "#{Luminati::Client::API_URL}/api/zone")).to have_been_made
      end

      it "returns OK which indicates the zone is created" do
        response = @client.add_zone(zone_info, plan_info)
        expect(response).to eq(expected_body)
      end

      describe "when the given API token has the limited permission" do
        let(:expected_status) { 401 }
        let(:expected_body) { "Not enough permissions" }

        it "returns an error" do
          response = @client.add_zone(zone_info, plan_info)
          expect(response["response_body"]).to eq(expected_body)
        end
      end
    end

    describe "when it gets a valid zone info and an invalid plan info" do
      let(:plan_info) { {} }
      let(:body) do
        {
          zone: zone_info
        }
      end
      let(:expected_status) { 400 }
      let(:expected_body) { "\"plan\" is missing from body" }

      it "returns an error" do
        response = @client.add_zone(zone_info, plan_info)
        expect(response["response_body"]).to eq(expected_body)
      end
    end

    describe "when it gets an invalid zone info and a valid plan info" do
      let(:zone_info) { {} }
      let(:body) do
        {
          plan: plan_info
        }
      end
      let(:expected_status) { 400 }
      let(:expected_body) { "\"zone\" is missing from body" }

      it "returns an error" do
        response = @client.add_zone(zone_info, plan_info)
        expect(response["response_body"]).to eq(expected_body)
      end
    end

    describe "when it gets an invalid zone info and an invalid plan info" do
      let(:zone_info) { {} }
      let(:plan_info) { {} }
      let(:body) { {} }
      let(:expected_status) { 400 }
      let(:expected_body) { "\"zone\" is missing from body" }

      it "returns an error" do
        response = @client.add_zone(zone_info, plan_info)
        expect(response["response_body"]).to eq(expected_body)
      end
    end
  end

  describe "#remove_zone" do
    let(:zone_name) { "existingzonename" }
    let(:expected_status) { 200 }
    let(:expected_body) { "OK" }

    before do
      stub_request(:delete, "#{Luminati::Client::API_URL}/api/zone")
        .with(body: { zone: zone_name })
        .to_return(status: expected_status, body: expected_body)
    end

    describe "when it gets a valid zone name" do
      it "sends a request to a correct endpoint" do
        @client.remove_zone(zone_name)
        expect(a_request(:delete, "#{Luminati::Client::API_URL}/api/zone")).to have_been_made
      end

      it "returns OK which indicates the zone is created" do
        response = @client.remove_zone(zone_name)
        expect(response).to eq(expected_body)
      end
    end

    describe "when it gets an invalid zone name" do
      let(:zone_name) { "somethinginvalid" }
      let(:expected_status) { 400 }
      let(:expected_body) { "No such zone: #{zone_name}" }

      it "returns an error" do
        response = @client.remove_zone(zone_name)
        expect(response["response_body"]).to eq(expected_body)
      end
    end
  end

  describe "#zone_passwords" do
    let(:zone_name) { "existingzonename" }
    let(:expected_status) { 200 }
    let(:expected_body) { "{\"passwords\":[\"passwordforzone\"]}" }

    before do
      stub_request(:get, "#{Luminati::Client::API_URL}/api/zone/passwords?zone=#{zone_name}")
        .to_return(status: expected_status, body: expected_body)
    end

    describe "when it gets a valid zone name" do
      it "sends a request to a correct endpoint" do
        @client.zone_passwords(zone_name)
        expect(a_request(:get, "#{Luminati::Client::API_URL}/api/zone/passwords?zone=#{zone_name}")).to have_been_made
      end

      it "returns passwords" do
        response = @client.zone_passwords(zone_name)
        expect(response["passwords"]).to_not be_empty
      end
    end

    describe "when it gets an invalid zone name" do
      let(:zone_name) { "somethinginvalid" }
      let(:expected_status) { 422 }
      let(:expected_body) { "Unknown zone" }

      it "returns an error" do
        response = @client.zone_passwords(zone_name)
        expect(response["response_body"]).to eq(expected_body)
      end
    end
  end

  describe "#zone_permissions" do
    let(:zone_name) { "existingzonename" }
    let(:expected_status) { 200 }
    let(:expected_body) { "{\"perms\":[\"country\",\"ip\"]}" }

    before do
      stub_request(:get, "#{Luminati::Client::API_URL}/api/zone/permissions?zone=#{zone_name}")
        .to_return(status: expected_status, body: expected_body)
    end

    describe "when it gets a valid zone name" do
      it "sends a request to a correct endpoint" do
        @client.zone_permissions(zone_name)
        expect(a_request(:get, "#{Luminati::Client::API_URL}/api/zone/permissions?zone=#{zone_name}")).to have_been_made
      end

      it "returns permissions" do
        response = @client.zone_permissions(zone_name)
        expect(response["perms"]).to_not be_empty
      end
    end

    describe "when it gets an invalid zone name" do
      let(:zone_name) { "somethinginvalid" }
      let(:expected_status) { 422 }
      let(:expected_body) { "Unknown zone" }

      it "returns an error" do
        response = @client.zone_permissions(zone_name)
        expect(response["response_body"]).to eq(expected_body)
      end
    end
  end

  describe "#zone_status" do
    let(:zone_name) { "existingzonename" }
    let(:expected_status) { 200 }
    let(:expected_body) { "{\"status\":\"active\"}" }

    before do
      stub_request(:get, "#{Luminati::Client::API_URL}/api/zone/status?zone=#{zone_name}")
        .to_return(status: expected_status, body: expected_body)
    end

    describe "when it gets a valid zone name" do
      it "sends a request to a correct endpoint" do
        @client.zone_status(zone_name)
        expect(a_request(:get, "#{Luminati::Client::API_URL}/api/zone/status?zone=#{zone_name}")).to have_been_made
      end

      it "returns status" do
        response = @client.zone_status(zone_name)
        expect(response["status"]).to_not be_empty
      end
    end

    describe "when it gets an invalid zone name" do
      let(:zone_name) { "somethinginvalid" }
      let(:expected_status) { 422 }
      let(:expected_body) { "Unknown zone" }

      it "returns an error" do
        response = @client.zone_status(zone_name)
        expect(response["response_body"]).to eq(expected_body)
      end
    end
  end

  describe "#active_zones" do
    let(:expected_status) { 200 }
    let(:expected_body) { "[{\"name\":\"existingzone\",\"type\":\"dc\"}]" }

    before do
      stub_request(:get, "#{Luminati::Client::API_URL}/api/zone/get_active_zones")
        .to_return(status: expected_status, body: expected_body)
    end

    describe "when it gets a valid zone name" do
      it "sends a request to a correct endpoint" do
        @client.active_zones
        expect(a_request(:get, "#{Luminati::Client::API_URL}/api/zone/get_active_zones")).to have_been_made
      end

      it "returns active zones" do
        response = @client.active_zones
        expect(response.size).to_not eq(0)
      end
    end
  end
end
