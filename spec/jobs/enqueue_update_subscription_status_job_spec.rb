# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EnqueueUpdateSubscriptionStatusJob, type: :job do
  describe '#perform' do
    let!(:users) { create_list(:user, 3) }
    let(:user_ids) { users.map(&:id) }
    let(:job_instances) { user_ids.map { |id| UpdateSubscriptionStatusJob.new(id) } }

    before do
      allow(User).to receive(:pluck_in_batches).with(:id).and_yield(user_ids)
      allow(UpdateSubscriptionStatusJob).to receive(:new).and_return(*job_instances)
    end

    it 'enqueues jobs for all users in a batch', :aggregate_failures do
      expect(ActiveJob).to receive(:perform_all_later) do |jobs|
        expect(jobs.size).to eq(user_ids.size)
        expect(jobs).to all(be_an_instance_of(UpdateSubscriptionStatusJob))
      end

      described_class.new.perform
    end
  end
end
