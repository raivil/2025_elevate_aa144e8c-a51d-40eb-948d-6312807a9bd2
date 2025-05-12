# frozen_string_literal: true

class ElevateService < ElevateApiClient
  def get_user_billing_status(user_id)
    api_client.get("/api/v1/users/#{user_id}/billing")
  end
end
