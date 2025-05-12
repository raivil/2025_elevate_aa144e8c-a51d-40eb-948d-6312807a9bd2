# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSerializer do
  subject(:serialization) { ActiveModelSerializers::Adapter.create(serializer).as_json }

  let(:fixed_id) { SecureRandom.uuid }
  let(:user) { create(:user, id: fixed_id) }
  let(:serializer) { described_class.new(user) }

  it 'includes the correct attributes', :aggregate_failures do
    expect(serialization[:email]).to eq(user.email)
    expect(serialization[:id]).to eq(fixed_id)
  end
end
