# frozen_string_literal: true

class UpdateSubscriptionStatusJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    Users::SubscriptionStatusService.new.update_subscription_status!(user_id)
  end
end
