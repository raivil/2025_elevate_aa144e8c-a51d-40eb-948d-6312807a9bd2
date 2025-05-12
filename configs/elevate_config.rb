# frozen_string_literal: true

class ElevateConfig < ApplicationConfig
  attr_config access_token: "fake-access-token"
  attr_config api_host: "https://cgjresszgg.execute-api.eu-west-1.amazonaws.com"
  required :access_token, :api_host
end
