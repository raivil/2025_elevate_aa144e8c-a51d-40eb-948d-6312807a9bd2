# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  has_many :game_events, dependent: :restrict_with_error

  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  def total_games_played
    # makes use of the counter cache to avoid counting the game events every time.
    count_of_game_events
  end

  def stats
    {
      total_games_played: total_games_played
    }
  end

  def subscription_status
    # If we have no status or it's older than 24 hours, enqueue it
    enqueue_fetch_subscription_status_from_api if subscription_status_needs_refresh?

    # Return the stored status or "processing" if we still don't have one
    self[:subscription_status].presence || "processing"
  end

  def subscription_status_needs_refresh?
    self[:subscription_status].blank? ||
      self[:subscription_status_last_updated_at].blank? ||
      self[:subscription_status_last_updated_at] < 24.hours.ago
  end

  private

  def enqueue_fetch_subscription_status_from_api
    UpdateSubscriptionStatusJob.perform_later(id)
  end
end
