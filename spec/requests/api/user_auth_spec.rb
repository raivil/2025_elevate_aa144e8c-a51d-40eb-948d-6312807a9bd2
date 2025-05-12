# frozen_string_literal: true

require 'rails_helper'

describe 'User Sign-up and Authentication API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
  let(:signup_url) { '/api/user' }
  let(:login_url) { '/api/sessions' }

  describe 'POST /api/user (sign up)' do
    context 'with valid parameters' do
      subject(:post_signup) { post signup_url, params: valid_params, headers: headers }

      let(:valid_params) { { email: 'test@example.com', password: 'StrongPassword123' }.to_json }

      it 'creates a new user and returns 201', :aggregate_failures do
        post_signup
        expect(response).to have_http_status(201)
        expect(response.parsed_body).to include('id', 'email')
      end
    end

    context 'with invalid parameters' do
      subject(:post_signup) { post signup_url, params: invalid_params, headers: headers }

      let(:invalid_params) { { email: '', password: '' }.to_json }

      it 'does not create user and returns 422', :aggregate_failures do
        post_signup
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to have_key('errors')
      end
    end
  end

  describe 'POST /api/sessions (login)' do
    let!(:user) { create(:user, email: 'login@example.com', password: 'Password123') }

    context 'with correct credentials' do
      subject(:post_login) { post login_url, params: login_params, headers: headers }

      let(:login_params) { { email: user.email, password: 'Password123' }.to_json }

      it 'logs in the user and returns token', :aggregate_failures do
        post_login
        expect(response).to have_http_status(:ok)
        body = response.parsed_body
        expect(body).to have_key('token')
        expect(body['token']).to be_present
      end
    end

    context 'with incorrect credentials' do
      subject(:post_login) { post login_url, params: wrong_params, headers: headers }

      let(:wrong_params) { { email: user.email, password: 'wrong' }.to_json }

      it 'returns 401 for wrong credentials', :aggregate_failures do
        post_login
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body).to have_key('error')
      end
    end
  end
end
