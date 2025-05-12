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
end
