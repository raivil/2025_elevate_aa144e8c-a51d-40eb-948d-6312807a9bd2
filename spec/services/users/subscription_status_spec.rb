# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SubscriptionStatus do
  let(:service) { described_class.new }
  let(:user) { create(:user) }
  let(:billing_service) { instance_double(Billing::SubscriptionService) }
  let(:successful_result) { double(success?: true, data: { "subscription_status" => "active" }) }
  let(:failed_result) { double(success?: false, error: "API error") }

  before do
    allow(Billing::SubscriptionService).to receive(:new).and_return(billing_service)
  end

  describe '#update_subscription_status!' do
    context 'when the billing service returns a successful result', :aggregate_failures do
      before do
        allow(billing_service).to receive(:fetch_status_from_api)
          .with(user.id)
          .and_return(successful_result)
      end

      it 'updates the user subscription status' do
        expect {
          service.update_subscription_status!(user.id)
        }.to change { user.reload.subscription_status }.to('active')
                                                       .and change(user, :subscription_status_last_updated_at).from(nil)
      end
    end

    context 'when the billing service returns a failed result', :aggregate_failures do
      before do
        allow(billing_service).to receive(:fetch_status_from_api)
          .with(user.id)
          .and_return(failed_result)
      end

      it 'raises an error' do
        expect {
          service.update_subscription_status!(user.id)
        }.to raise_error(StandardError)
      end

      it 'does not update the user' do
        expect {
          begin
            service.update_subscription_status!(user.id)
          rescue StandardError
            # Catch the error to check the user state
          end
        }.not_to change { user.reload.attributes }
      end
    end
  end
end
