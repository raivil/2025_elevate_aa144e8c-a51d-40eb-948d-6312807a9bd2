# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Result do
  describe '#initialize' do
    it 'creates a successful result', :aggregate_failures do
      result = described_class.new(true, 'data')
      expect(result.success).to be true
      expect(result.data).to eq('data')
      expect(result.error).to be_nil
    end

    it 'creates a failed result', :aggregate_failures do
      result = described_class.new(false, nil, 'error')
      expect(result.success).to be false
      expect(result.data).to be_nil
      expect(result.error).to eq('error')
    end
  end

  describe '#success?' do
    it 'returns true for a successful result' do
      result = described_class.new(true)
      expect(result.success?).to be true
    end

    it 'returns false for a failed result' do
      result = described_class.new(false)
      expect(result.success?).to be false
    end
  end

  describe '#failure?' do
    it 'returns false for a successful result' do
      result = described_class.new(true)
      expect(result.failure?).to be false
    end

    it 'returns true for a failed result' do
      result = described_class.new(false)
      expect(result.failure?).to be true
    end
  end
end
