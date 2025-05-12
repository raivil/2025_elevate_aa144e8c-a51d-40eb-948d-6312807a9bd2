# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Billing::SubscriptionService do
  let(:service) { described_class.new }

  describe '#fetch_status_from_api' do
    let(:user_id) { 123 }

    context 'when the API request is successful' do
      it 'returns success with the subscription status' do
        allow(ElevateService).to receive_message_chain(:new, :get_user_billing_status)
          .with(user_id)
          .and_return('active')

        result = service.fetch_status_from_api(user_id)

        expect(result).to be_success
        expect(result.data).to eq('active')
      end
    end

    context 'when the API request fails' do
      it 'returns failure with the error message' do
        allow(ElevateService).to receive_message_chain(:new, :get_user_billing_status)
          .with(user_id)
          .and_raise(StandardError.new('API error'))

        result = service.fetch_status_from_api(user_id)

        expect(result).to be_failure
        expect(result.error).to eq('User not found or network error occurred')
      end
    end
  end
end
