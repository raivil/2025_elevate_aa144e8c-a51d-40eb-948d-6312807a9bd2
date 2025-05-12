# frozen_string_literal: true

class Users::SubscriptionStatus
  class SubscriptionRetrieveFailedError < StandardError; end

    def update_subscription_status!(user_id)
      update_subscription_status_from_api(user_id)
    end

  private

    def update_subscription_status_from_api(user_id)
      result = Billing::SubscriptionService.new.fetch_status_from_api(user_id)

      raise SubscriptionRetrieveFailedError, "Subscription retrieve failed: #{result.error}" unless result.success?

        user = User.find(user_id)
        user.update(subscription_status: result.data["subscription_status"],
                    subscription_status_last_updated_at: Time.current)
    end
end
