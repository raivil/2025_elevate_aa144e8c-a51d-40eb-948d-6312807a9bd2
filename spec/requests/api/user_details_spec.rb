# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Details API', type: :request do
  let(:user) { create(:user, email: 'test@example.com', password: 'password123') }

  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }
  let(:auth_headers) { Devise::JWT::TestHelpers.auth_headers(headers, user) }

  let(:unauth_headers) { { 'Content-Type' => 'application/json' } }

  describe 'GET /api/user' do
    context 'when user has no game events' do
      subject(:get_user) { get '/api/user', headers: auth_headers }

      before do
        # Set the subscription status directly in the database
        user.update(
          subscription_status: 'active',
          subscription_status_last_updated_at: Time.current
        )
      end

      it 'returns user details with stats showing zero games played', :aggregate_failures do
        get_user
        expect(response).to have_http_status(:ok)
        json = response.parsed_body

        expect(json['user']).to include('id', 'email', 'stats', 'subscription_status')
        expect(json['user']['email']).to eq(user.email)
        expect(json['user']['stats']['total_games_played']).to eq(0)
        expect(json['user']['subscription_status']).to eq('active')
      end
    end

    context 'when user has game events' do
      subject(:get_user) { get '/api/user', headers: auth_headers }

      before do
        3.times do |i|
          create(:game_event,
                 user: user,
                 game_name: "Game #{i}",
                 occurred_at: Time.current - i.days)
        end

        # Set the subscription status directly in the database
        user.update(
          subscription_status: 'expired',
          subscription_status_last_updated_at: Time.current
        )
      end

      it 'returns user details with correct stats', :aggregate_failures do
        get_user
        expect(response).to have_http_status(:ok)
        json = response.parsed_body

        expect(json['user']).to include('id', 'email', 'stats', 'subscription_status')
        expect(json['user']['email']).to eq(user.email)
        expect(json['user']['stats']['total_games_played']).to eq(3)
        expect(json['user']['subscription_status']).to eq('expired')
      end
    end

    context 'when subscription status is missing' do
      subject(:get_user) { get '/api/user', headers: auth_headers }

      it 'returns processing status and triggers job', :aggregate_failures do
        expect(UpdateSubscriptionStatusJob).to receive(:perform_later).with(user.id)

        get_user
        expect(response).to have_http_status(:ok)
        json = response.parsed_body

        expect(json['user']).to include('subscription_status')
        expect(json['user']['subscription_status']).to eq('processing')
      end
    end

    context 'when not authenticated' do
      subject(:get_user) { get '/api/user', headers: unauth_headers }

      it 'returns unauthorized status', :aggregate_failures do
        get_user
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
