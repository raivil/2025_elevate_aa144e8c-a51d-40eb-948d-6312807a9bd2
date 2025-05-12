# frozen_string_literal: true

class ElevateApiClient
  attr_reader :jwt_token, :api_client

  def initialize
    @jwt_token = ElevateConfig.jwt_token
    @api_client = JsonApiClient.new(ElevateConfig.api_host, headers)
  end

  private

  def headers
    { "Authorization" => "Bearer #{jwt_token}" }
  end
end
