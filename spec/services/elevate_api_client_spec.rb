# frozen_string_literal: true

require "rails_helper"

RSpec.describe ElevateApiClient, type: :service do
  subject(:service) { described_class.new }

  describe "#object" do
    it { expect(service.jwt_token).to eq(ElevateConfig.jwt_token) }
    it { expect(service.api_client).to be_an_instance_of(JsonApiClient) }
  end
end
