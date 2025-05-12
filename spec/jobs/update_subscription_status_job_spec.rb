# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateSubscriptionStatusJob, type: :job do
  describe '#perform' do
    let(:user) { create(:user) }
    let(:subscription_service) { instance_double(Users::SubscriptionStatusService) }

    before do
      # Handle the service not being defined yet with a stub
      stub_const("Users::SubscriptionStatusService", Class.new)
      allow(Users::SubscriptionStatusService).to receive(:new).and_return(subscription_service)
    end

    it 'calls the subscription status service with the correct user ID', :aggregate_failures do
      expect(subscription_service).to receive(:update_subscription_status!).with(user.id)
      described_class.new.perform(user.id)
    end

    context 'when the subscription service succeeds' do
      before do
        allow(subscription_service).to receive(:update_subscription_status!).with(user.id)
      end

      it 'completes successfully' do
        expect { described_class.new.perform(user.id) }.not_to raise_error
      end
    end

    context 'when the subscription service raises an error' do
      before do
        allow(subscription_service).to receive(:update_subscription_status!)
          .with(user.id)
          .and_raise(StandardError.new('Service failure'))
      end

      it 'allows the error to propagate' do
        expect { described_class.new.perform(user.id) }.to raise_error(StandardError, 'Service failure')
      end
    end
  end

  describe '.perform_later' do
    let(:user) { create(:user) }

    it 'enqueues the job' do
      expect {
        described_class.perform_later(user.id)
      }.to have_enqueued_job(described_class).with(user.id)
    end
  end
end
