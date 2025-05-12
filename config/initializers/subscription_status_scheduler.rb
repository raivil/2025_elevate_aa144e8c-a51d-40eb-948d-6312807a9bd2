# frozen_string_literal: true

# Schedule the initial update of subscription statuses when the application starts
Rails.application.config.after_initialize do
  # Only run in production or if explicitly enabled
  if Rails.env.production? || ENV['ENABLE_SUBSCRIPTION_UPDATES'] == 'true'
    # Schedule the job to run a bit after server start
    UpdateSubscriptionStatusJob.set(wait: 5.minutes).perform_later('update_all')
    Rails.logger.info("Scheduled initial subscription status update job")
  end
end