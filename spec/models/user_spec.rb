# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe 'validations', :aggregate_failures do
    specify "simple" do
      %i(email password).each do |attr|
        expect(user).to validate_presence_of(attr)
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:game_events) }
  end

  describe '#total_games_played' do
    let(:user) { create(:user) }

    it 'returns 0 when user has no game events' do
      expect(user.total_games_played).to eq(0)
    end

    it 'returns correct count when user has game events' do
      create_list(:game_event, 3, user: user)
      # Counter cache should be automatically updated
      expect(user.reload.total_games_played).to eq(3)
    end

    it 'uses the counter cache for performance' do
      create_list(:game_event, 5, user: user)
      user.reload

      # Force count_of_game_events to a different value to verify it's using the counter cache
      user.update_column(:count_of_game_events, 10) # rubocop:disable Rails/SkipsModelValidations

      # Should use the counter cache value, not query the association
      expect(user.total_games_played).to eq(10)
    end
  end

  describe '#subscription_status' do
    let(:user) { create(:user) }

    context 'when subscription status is already set' do
      before do
        user.update(
          subscription_status: 'active',
          subscription_status_last_updated_at: Time.current
        )
      end

      it 'returns the stored status without API call' do
        expect(UpdateSubscriptionStatusJob).not_to receive(:perform_later)
        expect(user.subscription_status).to eq('active')
      end
    end

    context 'when subscription status is not set' do
      it 'enqueues a job to fetch the status and returns "processing"' do
        expect(UpdateSubscriptionStatusJob).to receive(:perform_later).with(user.id)
        expect(user.subscription_status).to eq('processing')
      end
    end

    context 'when subscription status is outdated' do
      before do
        user.update(
          subscription_status: 'expired',
          subscription_status_last_updated_at: 25.hours.ago
        )
      end

      it 'enqueues a job and returns the existing status' do
        expect(UpdateSubscriptionStatusJob).to receive(:perform_later).with(user.id)
        expect(user.subscription_status).to eq('expired')
      end
    end
  end

  describe '#subscription_status_needs_refresh?' do
    let(:user) { create(:user) }

    it 'returns true when subscription_status is nil' do
      expect(user).to be_subscription_status_needs_refresh
    end

    it 'returns true when subscription_status_last_updated_at is nil' do
      user.update(subscription_status: 'active')
      expect(user).to be_subscription_status_needs_refresh
    end

    it 'returns true when subscription_status_last_updated_at is older than 24 hours' do
      user.update(
        subscription_status: 'active',
        subscription_status_last_updated_at: 25.hours.ago
      )
      expect(user).to be_subscription_status_needs_refresh
    end

    it 'returns false when subscription status is recent' do
      user.update(
        subscription_status: 'active',
        subscription_status_last_updated_at: 1.hour.ago
      )
      expect(user).not_to be_subscription_status_needs_refresh
    end
  end

  describe '#enqueue_fetch_subscription_status_from_api' do
    let(:user) { create(:user) }

    it 'enqueues a job to update the subscription status' do
      expect(UpdateSubscriptionStatusJob).to receive(:perform_later).with(user.id)
      user.send(:enqueue_fetch_subscription_status_from_api)
    end
  end
end
