# frozen_string_literal: true

require 'rails_helper'

describe 'User Sign-up and Authentication API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
  let(:signup_url) { '/api/user' }
  let(:login_url) { '/api/sessions' }

  describe 'POST /api/user (sign up)' do
    context 'with valid parameters' do
      let(:valid_params) { { user: { email: 'test@example.com', password: 'StrongPassword123' } }.to_json }

      it 'creates a new user and returns 201' do
        post signup_url, params: valid_params, headers: headers
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['status']['message']).to match(/Signed up successfully/i)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { user: { email: '', password: '' } }.to_json }

      it 'does not create user and returns 422' do
        post signup_url, params: invalid_params, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['status']['message']).to match(/User couldn't be created/i)
      end
    end
  end

  describe 'POST /api/sessions (login)' do
    let!(:user) { User.create!(email: 'login@example.com', password: 'Password123') }
    let(:login_params) { { email: user.email, password: 'Password123' }.to_json }

    it 'logs in the user and returns 200 with JWT' do
      post login_url, params: login_params, headers: headers
      binding.irb
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['status']['message']).to match(/Logged in successfully/i)
      expect(body['data']).to be_present
    end

    it 'returns 401 for wrong credentials' do
      post login_url, params: { email: user.email, password: 'wrong' }.to_json, headers: headers
      expect(response).to have_http_status(:unauthorized).or have_http_status(:unprocessable_entity)
    end
  end
end
