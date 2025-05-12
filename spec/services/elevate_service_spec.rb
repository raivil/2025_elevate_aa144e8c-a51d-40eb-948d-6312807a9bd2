# frozen_string_literal: true

require "rails_helper"

RSpec.describe ElevateService, type: :service do
  subject(:service) { described_class.new }

  describe "#get_user_billing_status" do
    it "returns the user billing status expired" do
      response = service.get_user_billing_status(5)
      expect(response).to eq({ "subscription_status" => "expired" })
    end

    it "returns the user billing status active" do
      response = service.get_user_billing_status(15)
      expect(response).to eq({ "subscription_status" => "active" })
    end

    it "raises an error when the user is not found" do
      expect { service.get_user_billing_status(123) }.to raise_error(JsonApiClient::RequestError)
    end
  end
end
