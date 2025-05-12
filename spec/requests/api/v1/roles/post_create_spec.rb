# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::Roles", type: :request do
  describe "POST /api/v1/roles" do
    subject(:post_create) {
      post api_v1_roles_path, params: { role: valid_attributes }, headers: headers
    }

    let(:api_user) { create(:api_user) }
    let(:valid_attributes) { { name: "developer" } }

    let(:headers) {
      { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Token.encode_credentials(api_user.token) }
    }

    context "with valid parameters" do
      it "creates a new Role", :aggregate_failures do
        expect { post_create }.to change(Role, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response.parsed_body).to include({ name: "developer" })
      end
    end

    it "is authorized" do
      expect { post_create }.to be_authorized_to(:create?, an_instance_of(Role))
        .with(RolePolicy)
    end

    context "with invalid parameters" do
      it "does not create a new Role", :aggregate_failures do
        expect {
          post api_v1_roles_path, params: { role: { name: "ab" } }, headers: headers
        }.not_to change(Role, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response.parsed_body).to include({ errors: [ "Name is too short (minimum is 3 characters)" ] })
      end
    end

    context "when not authorized" do
      let(:headers) { { "HTTP_AUTHORIZATION" => nil } }

      it "fails to create a role", :aggregate_failures do
        expect { post_create }.not_to change(Role, :count)
        expect(response).to have_http_status(401)
        expect(response.content_type).to match(a_string_including("text/plain; charset=utf-8"))
        expect(response.parsed_body).to eq("HTTP Token: Access denied.\n")
      end
    end
  end
end
