# frozen_string_literal: true

FactoryBot.define do
  factory :game_event do
    user
    game_name { 'Brevity' }
    event_type { 'COMPLETED' }
    occurred_at { Time.current }
  end
end
