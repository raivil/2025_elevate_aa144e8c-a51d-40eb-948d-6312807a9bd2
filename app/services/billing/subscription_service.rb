# frozen_string_literal: true

# Services classes isolate the business logic of the application and are reusable.
# There are layers of services, each with a single responsibility.
# A configuration class, a base service class, an api class, and specific service classes.
class Billing::SubscriptionService < BaseService
  class SubscriptionError < StandardError; end

  def fetch_status_from_api(user_id)
    success(fetch_user_billing(user_id))
  rescue SubscriptionError => e
    failure(e.message)
  end

  private

  def fetch_user_billing(user_id)
    # TODO: use Retriable gem to retry on network errors
    ElevateService.new.get_user_billing_status(user_id)
  rescue StandardError => e
    handle_service_error(e, "User not found or network error occurred", SubscriptionError)
  end
end
