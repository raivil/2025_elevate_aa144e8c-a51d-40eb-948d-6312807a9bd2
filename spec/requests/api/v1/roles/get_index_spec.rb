# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::Roles", type: :request do
  subject(:get_index) { get api_v1_roles_path, headers: headers }

  let(:api_user) { create(:api_user) }

    let(:headers) {
 { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Token.encode_credentials(api_user.token) }
    }

  describe "GET /api/v1/roles" do
    it "returns a list of roles", :aggregate_failures do
      role1 = create(:role)
      role2 = create(:role, name: "Devops")
      get_index
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(a_string_including("application/json"))
      expect(response.parsed_body).to match([ { id: role1.id, name: role1.name }, { id: role2.id, name: role2.name } ])
    end

    it "authorizes roles scope", :aggregate_failures do
      expect { get_index }.to have_authorized_scope(:active_record_relation)
        .with(RolePolicy)
        .with_target { |target| expect(target).to eq(Role.all) }
    end

    it "is authorized" do
      expect { get_index }.to be_authorized_to(:index?, Role.all)
        .with(RolePolicy).with_context(user: api_user)
    end
  end
end
