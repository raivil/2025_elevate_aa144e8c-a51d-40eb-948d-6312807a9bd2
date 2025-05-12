# frozen_string_literal: true

require "rails_helper"

RSpec.describe JsonApiClient, type: :utility do
  subject(:api_client) { described_class.new("https://www.example.com") }

  describe "methods" do
    it { expect(api_client.get("/get")).to eq('{ "success": true }') }
    it { expect(api_client.delete("/delete")).to eq(200) }

    it do
      response = api_client.post("/post") do |r|
        r.body = "ping"
      end
      expect(response).to eq("pong")
    end

    it { expect(api_client.put("/put")).to eq(200) }

    it {
      expect {
        api_client.patch("/patch")
      }.to raise_error(JsonApiClient::RequestError, /responded with status 405/)
    }
  end
end
