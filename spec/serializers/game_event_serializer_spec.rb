# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/serializer_examples'

RSpec.describe GameEventSerializer, type: :serializer do
  let(:user) { create(:user) }
  let(:occurred_time) { Time.zone.parse('2025-01-01T12:00:00Z') }
  let(:game_event) do
    create(:game_event,
           user: user,
           game_name: 'Brevity',
           event_type: 'COMPLETED',
           occurred_at: occurred_time)
  end

  let(:serializer) { described_class.new(game_event) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer).as_json }

  it_behaves_like 'a valid serializer', %i(id game_name event_type occurred_at created_at updated_at)

  it 'includes the correct game_name' do
    expect(serialization[:game_name]).to eq('Brevity')
  end

  it 'includes the correct event_type' do
    expect(serialization[:event_type]).to eq('COMPLETED')
  end

  it 'includes the correct occurred_at time' do
    expect(serialization[:occurred_at]).to eq(occurred_time.as_json)
  end
end
