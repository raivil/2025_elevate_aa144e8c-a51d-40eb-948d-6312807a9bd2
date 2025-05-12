# frozen_string_literal: true

class GameEventSerializer < ActiveModel::Serializer
  attributes :id, :game_name, :event_type, :occurred_at, :created_at, :updated_at
end
