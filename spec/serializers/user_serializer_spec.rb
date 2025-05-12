# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/serializer_examples'

RSpec.describe UserSerializer, type: :serializer do
  let(:user) { create(:user, email: 'test@example.com') }
  let(:serializer) { described_class.new(user) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer).as_json }

  before do
    # Create some game events for the user
    create_list(:game_event, 3, user: user)
  end

  it_behaves_like 'a valid serializer', %i(id email stats subscription_status)

  it 'includes the correct user email' do
    expect(serialization[:email]).to eq(user.email)
  end

  it 'includes stats with total_games_played' do
    expect(serialization[:stats]).to include(total_games_played: 3)
  end

  context 'when user has no game events' do
    let(:user_without_events) { create(:user) }
    let(:serializer) { described_class.new(user_without_events) }
    let(:serialization) { ActiveModelSerializers::Adapter.create(serializer).as_json }

    it 'has total_games_played set to 0' do
      expect(serialization[:stats][:total_games_played]).to eq(0)
    end
  end
end
