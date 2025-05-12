# frozen_string_literal: true

require "rails_helper"

RSpec.describe ElevateConfig, type: :config do
  subject(:config) { described_class.new }

  specify do
    with_env("ELEVATE_JWT_TOKEN" => "new-ELEVATE-jwt_token",
             "ELEVATE_API_HOST" => "new-ELEVATE-host") do
      expect(config).to have_attributes(
        jwt_token: "new-ELEVATE-jwt_token",
        api_host: "new-ELEVATE-host"
      )
    end
  end

  specify "when checking for default value" do
    with_env("ELEVATE_JWT_TOKEN" => nil,
             "ELEVATE_API_HOST" => nil) do
      expect(config).to have_attributes(
        jwt_token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiaWxsaW5nIiwiaWF0IjoxNzQzMDg1NDk5LCJleHAiOm51bGwsImF1ZCI6Ind3dy5leGFtcGxlLmNvbSIsInN1YiI6ImJpbGxpbmdfY2xpZW50In0.aRwnR_QP6AlOv_JanMkbhwe9ACDcJc5184pXdR0ksXg",
        api_host: "https://interviews-accounts.elevateapp.com"
      )
    end
  end
end
