# frozen_string_literal: true

require "rails_helper"

RSpec.describe BaseService do
  let(:service) { Class.new(described_class).new }

  describe "#success" do
    it "returns a successful result", :aggregate_failures do
      result = service.send(:success, "data")
      expect(result).to be_a(Result)
      expect(result.success?).to be true
      expect(result.data).to eq("data")
    end

    it "returns a successful result without data", :aggregate_failures do
      result = service.send(:success)
      expect(result).to be_a(Result)
      expect(result.success?).to be true
      expect(result.data).to be_nil
    end
  end

  describe "#failure" do
    it "returns a failed result", :aggregate_failures do
      result = service.send(:failure, "error message")
      expect(result).to be_a(Result)
      expect(result.success?).to be false
      expect(result.error).to eq("error message")
    end
  end

  describe "#handle_service_error" do
    let(:error) { StandardError.new("Original error") }

    it "logs the error and raises a ServiceError", :aggregate_failures do
      expect do
        service.send(:handle_service_error, error, "Custom message")
        expect(Rails.logger).to have_received(:error).with("Custom message: Original error")
      end.to raise_error(BaseService::ServiceError, "Custom message")
    end

    it "raises a custom error class if provided" do
      custom_error_class = Class.new(StandardError)
      expect do
        service.send(:handle_service_error, error, "Custom message", custom_error_class)
      end.to raise_error(custom_error_class, "Custom message")
    end
  end

  describe BaseService::ServiceError do
    it "is a subclass of StandardError" do
      expect(described_class.superclass).to eq(StandardError)
    end
  end
end
