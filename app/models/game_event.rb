# frozen_string_literal: true

class GameEvent < ApplicationRecord
  # counter cache will use rails functionality to increment and decrement the count_of_game_events column on the user model
  # this will avoid queries on the database.
  # However, if we need to query with distinct game event types, a new structure is needed.
  belongs_to :user, counter_cache: :count_of_game_events

  EVENT_TYPE_COMPLETED = "COMPLETED"

  validates :game_name, presence: true
  validates :event_type, presence: true
  validates :occurred_at, presence: true

  validate :event_type_is_completed

  private

  def event_type_is_completed
    return if event_type == EVENT_TYPE_COMPLETED

      errors.add(:event_type, "must be 'COMPLETED'")
  end
end
