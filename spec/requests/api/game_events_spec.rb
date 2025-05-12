# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Game Events API', type: :request do
  let(:user) { create(:user, email: 'test@example.com', password: 'password123') }

  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }
  let(:auth_headers) { Devise::JWT::TestHelpers.auth_headers(headers, user) }

  let(:unauth_headers) do
    {
      'Content-Type' => 'application/json'
    }
  end

  let(:game_events_url) { '/api/user/game_events' }

  describe 'POST /api/user/game_events' do
    context 'with valid parameters' do
      subject(:post_game_event) { post game_events_url, params: valid_attributes, headers: auth_headers }

      let(:valid_attributes) do
        {
          game_event: {
            game_name: 'Brevity',
            type: 'COMPLETED',
            occurred_at: '2025-01-01T00:00:00.000Z'
          }
        }.to_json
      end

      it 'creates a new game event' do
        expect { post_game_event }.to change(GameEvent, :count).by(1)
      end

      it 'returns status code 201' do
        post_game_event
        expect(response).to have_http_status(:created)
      end

      it 'returns the created game event' do
        post_game_event
        expect(response.content_type).to match(%r{application/json})
        parsed_body = response.parsed_body
        expect(parsed_body).to include('id', 'game_name', 'event_type', 'occurred_at')
        expect(parsed_body['game_name']).to eq('Brevity')
        expect(parsed_body['event_type']).to eq('COMPLETED')
      end
    end

    context 'with invalid parameters' do
      subject(:post_game_event) { post game_events_url, params: invalid_attributes, headers: auth_headers }

      let(:invalid_attributes) do
        {
          game_event: {
            game_name: '',
            type: 'COMPLETED',
            occurred_at: '2025-01-01T00:00:00.000Z'
          }
        }.to_json
      end

      it 'does not create a new game event' do
        expect { post_game_event }.not_to change(GameEvent, :count)
      end

      it 'returns status code 422' do
        post_game_event
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns validation errors' do
        post_game_event
        expect(response.content_type).to match(%r{application/json})
        parsed_body = response.parsed_body
        expect(parsed_body).to have_key('errors')
      end
    end

    context 'with invalid event type' do
      subject(:post_game_event) { post game_events_url, params: invalid_type_attributes, headers: auth_headers }

      let(:invalid_type_attributes) do
        {
          game_event: {
            game_name: 'Brevity',
            type: 'STARTED',
            occurred_at: '2025-01-01T00:00:00.000Z'
          }
        }.to_json
      end

      it 'does not create a new game event' do
        expect { post_game_event }.not_to change(GameEvent, :count)
      end

      it 'returns validation errors for event type' do
        post_game_event
        expect(response.content_type).to match(%r{application/json})
        parsed_body = response.parsed_body
        expect(parsed_body['errors']).to have_key('event_type')
      end
    end

    context 'without authentication' do
      subject(:post_game_event) { post game_events_url, params: valid_attributes, headers: unauth_headers }

      let(:valid_attributes) do
        {
          game_event: {
            game_name: 'Brevity',
            type: 'COMPLETED',
            occurred_at: '2025-01-01T00:00:00.000Z'
          }
        }.to_json
      end

      it 'returns unauthorized status' do
        post_game_event
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
