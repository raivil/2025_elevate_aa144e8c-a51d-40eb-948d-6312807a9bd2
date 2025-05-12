# frozen_string_literal: true

class EnqueueUpdateSubscriptionStatusJob < ApplicationJob
  queue_as :default

  def perform
    User.pluck_in_batches(:id) do |ids|
      user_ids = ids.map { |id| UpdateSubscriptionStatusJob.new(id) }
      ActiveJob.perform_all_later(user_ids)
    end
  end
end
