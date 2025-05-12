# frozen_string_literal: true

FactoryBot.define do
  factory :api_user do
    user_id { SecureRandom.uuid }
    sequence(:token) { |n| "token_#{n}" }
  end
end
